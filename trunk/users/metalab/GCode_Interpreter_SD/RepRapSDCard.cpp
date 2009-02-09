#include <HardwareSerial.h>
#include "RepRapSDCard.h"
#include "fat.h"
#include "sd_raw.h"
#include "partition.h"
#include <string.h>

#if !USE_DYNAMIC_MEMORY
  struct partition_struct partition_handles[PARTITION_COUNT];
#endif

/*!
  Initializes SD card, returns an SDStatus (SDOK or an error).
  Will also open a partition, filesystem and root dir.
*/
uint8_t RepRapSDCard::init()
{
  if (!sd_raw_init()) {
    if (!sd_raw_available()) {
      Serial.println("No card present"); 
      return NO_CARD;
    }
    else
    {
      Serial.println("Card init failed"); 
      return INIT_FAILED;
    }
  }
  else if (!this->open_partition())
  {
    Serial.println("No partition"); 
    return NO_PARTITION;
  }
  else if (!this->open_filesys())
  {
    Serial.println("Can't open filesys"); 
    return NO_FILESYS;
  }
  else if (!this->openDir("/"))
  {
    Serial.println("Can't open /");
    return NO_ROOT;
  }
  return SDOK;
}

/*!
  Opens the first partition and stores it in this->partition.
  Returns true on success, false on error.
*/
bool RepRapSDCard::open_partition()
{
  this->partition = partition_open(sd_raw_read,
                                   sd_raw_read_interval,
                                   sd_raw_write,
                                   sd_raw_write_interval,
                                   0);

  if (!this->partition) {
    // If the partition did not open, assume the storage device
    // is a "superfloppy", i.e. has no MBR.
    this->partition = partition_open(sd_raw_read,
                                     sd_raw_read_interval,
                                     sd_raw_write,
                                     sd_raw_write_interval,
                                     -1);
  }
  
  if (!this->partition) return false;
  return true;
}

/*!
  Open file system. A partition must be opened first.
  Stores the filesystem in this->filesystem.
  Returns true on success, false on error.
*/
bool RepRapSDCard::open_filesys()
{
  this->filesystem = fat_open(this->partition);
  if (!this->filesystem) return false;
  return true;
}

/*!
  Prints SD card hardware and filesystem info to Serial
 */
void RepRapSDCard::printInfo()
{
  if (!this->filesystem) return;

  struct sd_raw_info disk_info;
  if (!sd_raw_get_info(&disk_info)) return;

  Serial.print("manuf:  0x"); 
  Serial.println(disk_info.manufacturer, HEX);
  Serial.print("oem:    ");
  Serial.println((char*) disk_info.oem);
  Serial.print("prod:   ");
  Serial.println((char*) disk_info.product);
  Serial.print("rev:    ");
  Serial.println(disk_info.revision, HEX);
  Serial.print("serial: 0x");
  Serial.println(disk_info.serial, HEX);
  Serial.print("date:   ");
  Serial.print(disk_info.manufacturing_month, DEC);
  Serial.println(disk_info.manufacturing_year);
  Serial.print("size:   ");
  Serial.print(disk_info.capacity / 1024 / 1024, DEC);
  Serial.println("MB");
  Serial.print("copy:   ");
  Serial.println(disk_info.flag_copy, DEC);
  Serial.print("wr.pr.: ");
  Serial.print(disk_info.flag_write_protect_temp, DEC);
  Serial.println(disk_info.flag_write_protect);
  Serial.print("format: ");
  Serial.println(disk_info.format, DEC);
  Serial.print("free:   ");
  Serial.print(fat_get_fs_free(this->filesystem));
  Serial.print("/");
  Serial.println(fat_get_fs_size(this->filesystem), DEC);
}

/*!
  Opens the given directory and stores the open dir in this->cwd.
*/
bool RepRapSDCard::openDir(const char *path)
{
  struct fat_dir_entry_struct dir;

  fat_get_dir_entry_of_path(this->filesystem, path, &dir);
  this->cwd = fat_open_dir(this->filesystem, &dir);
  if (!this->cwd) return false;
  return true;
}

/*!
  Finds the next entry in the current open directory.
  The filename (first 11 characters) are written to \e name.
  Files with attributes SYSTEM, HIDDEN or VOLUME are skipped.
*/
bool
RepRapSDCard::getNextEntry(char *name)
{
  fat_dir_entry_struct dir_entry;

  while (fat_read_dir(this->cwd, &dir_entry) &&
         dir_entry.attributes & 
         (FAT_ATTRIB_SYSTEM | FAT_ATTRIB_HIDDEN | FAT_ATTRIB_VOLUME)) { } 
  if (dir_entry.long_name[0] == '\0') return false;
     
  strncpy(name, dir_entry.long_name, 12);
  name[12] = 0;
  return true;
}

File *RepRapSDCard::openFile(const char* name)
{
  struct fat_dir_entry_struct file_entry;

  fat_reset_dir(this->cwd);
  while (fat_read_dir(this->cwd, &file_entry)) {
    // FIXME: Compare only 12 first chars
    if (strcmp(file_entry.long_name, name) == 0) {
      break;
    }
  }

  if (file_entry.long_name[0] == '\0') return NULL;

  return fat_open_file(this->filesystem, &file_entry);
}




uint8_t RepRapSDCard::create_file(char *name)
{
  struct fat_dir_entry_struct file_entry;
  return fat_create_file(cwd, name, &file_entry);
}

#include <HardwareSerial.h>
#include "RepRapSDCard.h"
#include "fat.h"
#include "sd_raw.h"
#include "partition.h"
#include <string.h>

#if !USE_DYNAMIC_MEMORY
  struct partition_struct partition_handles[PARTITION_COUNT];
#endif

void RepRapSDCard::print_disk_info()
{
  if (!filesystem) return;

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
    Serial.print(fat_get_fs_free(filesystem));
    Serial.print("/");
    Serial.println(fat_get_fs_size(filesystem), DEC);
}

/*!
  Opens the first partition and stores it in the partition instance variable.
*/
bool RepRapSDCard::open_partition(void)
{
  // open first partition
  partition = partition_open(sd_raw_read,
                             sd_raw_read_interval,
                             sd_raw_write,
                             sd_raw_write_interval,
                             0);

  if (!partition) {
    // If the partition did not open, assume the storage device
    // is a "superfloppy", i.e. has no MBR.
    partition = partition_open(sd_raw_read,
                               sd_raw_read_interval,
                               sd_raw_write,
                               sd_raw_write_interval,
                               -1);
  }

  if (!partition) return false;
  return true;
}


/*!
  Open file system. A partition must be opened first.
  Stores the filesystem in the filesystem instance variable.
*/
bool RepRapSDCard::open_filesys(void)
{
  filesystem = fat_open(partition);
  if (!filesystem) return false;
  return true;
}

/*!
  Opens the given directory and stores the open dir in the cwd instance variable.
*/
bool RepRapSDCard::open_dir(char *path)
{
  struct fat_dir_entry_struct dir;

  fat_get_dir_entry_of_path(filesystem, path, &dir);
  cwd = fat_open_dir(filesystem, &dir);
  if (!cwd) return false;
  return true;
}


uint8_t find_file_in_dir(struct fat_fs_struct* fs, struct fat_dir_struct* dd, const char* name, struct fat_dir_entry_struct* dir_entry)
{
  while (fat_read_dir(dd, dir_entry))
  {
    if (strcmp(dir_entry->long_name, name) == 0)
    {
      fat_reset_dir(dd);
      return 1;
    }
  }

  return 0;
}

struct fat_file_struct* open_file_in_dir(struct fat_fs_struct* fs, struct fat_dir_struct* dd, const char* name)
{
  struct fat_dir_entry_struct file_entry;

  if (!find_file_in_dir(fs, dd, name, &file_entry))
  {
    //Serial.println("File not found");
    return 0;
  }

  return fat_open_file(fs, &file_entry);
}


uint8_t RepRapSDCard::create_file(char *name)
{
  struct fat_dir_entry_struct file_entry;
  return fat_create_file(cwd, name, &file_entry);
}

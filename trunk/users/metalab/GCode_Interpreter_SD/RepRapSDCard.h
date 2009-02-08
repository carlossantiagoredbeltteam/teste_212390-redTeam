#ifndef _REPRAPSDCARD_H_
#define _REPRAPSDCARD_H_

#include "sd_raw.h"
#include "sd_raw_config.h"
#include "sd-reader_config.h"
#include "partition.h"
#include "partition_config.h"
#include "fat.h"

typedef struct fat_file_struct * File;

class RepRapSDCard
{
 public:
  struct partition_struct *partition;
  struct fat_fs_struct *filesystem;
  struct fat_dir_struct *cwd;
  struct fat_dir_entry_struct file_entry;

 public:
  RepRapSDCard(void) { }
  void print_disk_info();
  bool isAvailable(void) { return sd_raw_available(); }
  bool isLocked(void) { return sd_raw_locked(); }
  bool init_card(void) { return sd_raw_init(); }
  bool open_partition(void);
  bool open_filesys(void);
  bool open_dir(char *path);

  char *get_next_name_in_dir(void);
  File open_file(char *name);
  void close_file(File f) { fat_close_file(f); }
  uint8_t create_file(char *name);
  uint8_t seek_file(File f, int32_t *offset, uint8_t whence) {
    return fat_seek_file(f, offset, whence);
  }
  uint8_t reset_file(File f) { return fat_seek_file(f, 0, FAT_SEEK_SET); }
  uint16_t read_file(File f, uint8_t* buffer, uint16_t buffer_len) {
    return fat_read_file(f, buffer, buffer_len);
  }
  uint8_t write_file(File f, uint8_t *buff, uint8_t num) {
    return fat_write_file(f, buff, num);
  }
};

#endif

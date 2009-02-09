#ifndef _REPRAPSDCARD_H_
#define _REPRAPSDCARD_H_

#include "sd_raw.h"
#include "sd_raw_config.h"
#include "sd-reader_config.h"
#include "partition.h"
#include "partition_config.h"
#include "fat.h"

typedef struct fat_file_struct File;

class RepRapSDCard
{
 public:
  enum SDStatus {
    SDOK = 0,
    INIT_FAILED,
    NO_CARD,
    NO_PARTITION,
    NO_FILESYS,
    NO_ROOT
  };
  partition_struct *partition;     // Current partition
  fat_fs_struct *filesystem;       // Current filesystem
  fat_dir_struct *cwd;             // Current open directory

 public:
  RepRapSDCard() { }

  uint8_t init();

  void printInfo();
  bool getNextEntry(char *name);



  bool openDir(const char *path);
  File *openFile(const char *name);
  void closeFile(File *f) { fat_close_file(f); }
  uint16_t readFile(File *f, uint8_t* buffer, uint16_t buffer_len) {
    return fat_read_file(f, buffer, buffer_len);
  }


  uint8_t create_file(char *name);
  uint8_t seek_file(File *f, int32_t *offset, uint8_t whence) {
    return fat_seek_file(f, offset, whence);
  }
  uint8_t reset_file(File *f) { return fat_seek_file(f, 0, FAT_SEEK_SET); }
  uint8_t write_file(File *f, uint8_t *buff, uint8_t num) {
    return fat_write_file(f, buff, num);
  }

private:
  bool open_partition();
  bool open_filesys();
};

#endif

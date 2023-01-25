import 'dart:io';

double getFileSize(File file){
  int sizeInBytes = file.lengthSync();
  double sizeInMb = sizeInBytes / ( 1024);
  return sizeInMb;
}

//Alternatively for extension:

extension FileUtils on File {
  get size {
    int sizeInBytes = lengthSync();
    double sizeInKb = sizeInBytes / (1024 );
    return sizeInKb;
  }
}
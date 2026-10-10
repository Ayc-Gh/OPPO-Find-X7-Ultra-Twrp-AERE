/* SPDX-License-Identifier: Apache-2.0 */
#include <hardware/hardware.h>
#include <dlfcn.h>
#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>
#include <string.h>
int main(int argc, char **argv) {
  if (argc != 2 || strcmp(argv[1], "--phy110-stock-audio") || getuid()!=0) return 64;
  void *hidl=dlopen("libhidlbase.so",RTLD_NOW|RTLD_GLOBAL);
  if (!hidl) {fprintf(stderr,"hidl: %s\n",dlerror());return 65;}
  void (*configure)(size_t,bool)=dlsym(hidl,"_ZN7android8hardware22configureRpcThreadpoolEmb");
  void (*join)(void)=dlsym(hidl,"_ZN7android8hardware17joinRpcThreadpoolEv");
  if (!configure || !join) {fprintf(stderr,"HIDL entry points unavailable\n");return 66;}
  configure(8,true);
  void *library=dlopen("/tmp/phy110-audio-vendor/lib64/hw/audio.primary.pineapple.so",RTLD_NOW|RTLD_GLOBAL);
  if (!library) {fprintf(stderr,"HAL: %s\n",dlerror());return 67;}
  hw_module_t *module=dlsym(library,HAL_MODULE_INFO_SYM_AS_STR);
  if (!module || !module->methods || !module->methods->open) return 68;
  hw_device_t *device=NULL;
  int rc=module->methods->open(module,"audio_hw_if",&device);
  fprintf(stderr,"PHY110 audio HAL open=%d device=%s\n",rc,device?"ready":"missing");
  if (rc || !device) return 69;
  join();
  return 70;
}

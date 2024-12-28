#!/bin/bash
# set -ex
#replace all occurances of CPU's in qemu with our fake one
#run this file in the QEMU-SRC directory,

#borrowed and modified from https://github.com/kevoreilly/CAPEv2/blob/master/installer/kvm-qemu.sh
#My computer uses an AMD CPU, if you use Intel you should replace all AMD references with Intel.


#cpuid="Intel(R) Core(TM) i3-4130 CPU"
cpuid="AMD EPYC(tm) 9654 Processor"

#KVMKVMKVM\\0\\0\\0 replacement
#hypervisor_string_replacemnt="GenuineIntel"
hypervisor_string_replacemnt="AuthenticAMD"

#QEMU HARDDISK
#qemu_hd_replacement="SanDisk SDSSD"
qemu_hd_replacement="Samsung SSD 970 EVO Plus 1TB"
#QEMU DVD-ROM
#qemu_dvd_replacement="HL-DT-ST WH1"
#qemu_dvd_replacement="HL-PV-SG WB4"
qemu_dvd_replacement="HL-PQ-SV WB8"

#BOCHSCPU
#bochs_cpu_replacement="INTELCPU"
bochs_cpu_replacement="AMDCPU"

#QEMU\/Bochs
#qemu_bochs_cpu='INTEL\/INTEL'
qemu_bochs_cpu='AMD\/AMD'

#qemu
#qemu_space_replacement="intel "
qemu_space_replacement="amd "

#06\/23\/99
src_misc_bios_table="10\/12\/22"

#04\/01\/2014
src_bios_table_date2="12\/05\/2022"

#01\/01\/2011
src_fw_smbios_date="12\/05\/2022"

# what to use as a replacement for QEMU in the tablet info
PEN_REPLACER='Wacom'

# what to use as a replacement for QEMU in the scsi disk info
SCSI_REPLACER='Seagate'

# what to use as a replacement for QEMU in the atapi disk info
ATAPI_REPLACER='Seagate'

# what to use as a replacement for QEMU in the microdrive info
MICRODRIVE_REPLACER='Seagate'

# what to use as a replacement for QEMU in bochs in drive info
BOCHS_BLOCK_REPLACER='Seagate'
BOCHS_BLOCK_REPLACER2='Seagate'
BOCHS_BLOCK_REPLACER3='Seagate'
function _sed_aux(){
    # pattern path error_msg
    if [ -f "$2" ] && ! sed -i "$1" "$2"; then
        echo "$3"
    fi
}
# what to use as a replacement for BXPC in bochs in ACPI info
BXPC_REPLACER='Tachibana'
function replace_qemu_clues_public() {
    echo '[+] Patching QEMU clues'
    _sed_aux "s/QEMU HARDDISK/$qemu_hd_replacement/g" hw/ide/core.c 'QEMU HARDDISK was not replaced in core.c'
    _sed_aux "s/QEMU HARDDISK/$qemu_hd_replacement/g" hw/scsi/scsi-disk.c 'QEMU HARDDISK was not replaced in scsi-disk.c'
    _sed_aux "s/QEMU DVD-ROM/$qemu_dvd_replacement/g" hw/ide/core.c 'QEMU DVD-ROM was not replaced in core.c'
    _sed_aux "s/QEMU DVD-ROM/$qemu_dvd_replacement/g" hw/ide/atapi.c 'QEMU DVD-ROM was not replaced in atapi.c'
    _sed_aux "s/QEMU PenPartner tablet/$PEN_REPLACER PenPartner tablet/g" hw/usb/dev-wacom.c 'QEMU PenPartner tablet'
    _sed_aux 's/s->vendor = g_strdup("QEMU");/s->vendor = g_strdup("'"$SCSI_REPLACER"'");/g' hw/scsi/scsi-disk.c 'Vendor string was not replaced in scsi-disk.c'
    _sed_aux "s/QEMU CD-ROM/$qemu_dvd_replacement/g" hw/scsi/scsi-disk.c 'Vendor string was not replaced in scsi-disk.c'
    _sed_aux 's/padstr8(buf + 8, 8, "QEMU");/padstr8(buf + 8, 8, "'"$ATAPI_REPLACER"'");/g'  hw/ide/atapi.c 'padstr was not replaced in atapi.c'
    _sed_aux 's/QEMU MICRODRIVE/'"$MICRODRIVE_REPLACER"' MICRODRIVE/g' hw/ide/core.c 'QEMU MICRODRIVE was not replaced in core.c'
    _sed_aux "s/KVMKVMKVM\\\\0\\\\0\\\\0/$hypervisor_string_replacemnt/g" target/i386/kvm/kvm.c 'KVMKVMKVM was not replaced in kvm.c'
    _sed_aux 's/"bochs"/"'"$BOCHS_BLOCK_REPLACER"'"/g' block/bochs.c 'BOCHS was not replaced in block/bochs.c'
    _sed_aux 's/"BOCHS "/"ALASKA"/g' include/hw/acpi/aml-build.h 'BOCHS was not replaced in block/bochs.c'
    _sed_aux 's/Bochs Pseudo/Intel RealTime/g' roms/ipxe/src/drivers/net/pnic.c 'Bochs Pseudo was not replaced in roms/ipxe/src/drivers/net/pnic.c'
    _sed_aux 's/BXPC/'"$BXPC_REPLACER"'/g' include/hw/acpi/aml-build.h 'BXPC was not replaced in include/hw/acpi/aml-build.h'
}
replace_qemu_clues_public

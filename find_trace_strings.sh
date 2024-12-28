#!/usr/bin/env bash
#
# Script: find_vm_strings.sh
# Purpose: Locate possible references to QEMU/Bochs/VM markers in the EDK2-OVMF
#          (or any) source tree.
#
# Usage:   ./find_vm_strings.sh [SOURCE_DIRECTORY]
#
#This is a script to find any potential giveaways!
#You can output the results into an LLM, or manually write a script to actually remove them.

# Default to current directory if no path is provided
SEARCH_DIR="${1:-.}"

# Common VM or hypervisor references:
PATTERNS=(
  "QEMU"
  "Bochs"
  "KVMKVMKVM"
  "KVM"
  "BXPC"
  "GenuineIntel"
  "AuthenticAMD"
  "QEMU HARDDISK"
  "QEMU DVD-ROM"
  "QEMU MICRODRIVE"
  "Bochs Pseudo"
)

echo "[+] Searching for virtualization-related strings in: $SEARCH_DIR"
echo

# Loop through each pattern and grep for it recursively
for pattern in "${PATTERNS[@]}"; do
  echo "=== Searching for '$pattern' ==="
  # -r: recursive
  # -n: show line number
  # -H: show filename
  # -I: skip binary files
  grep -rnIH --color=always "$pattern" "$SEARCH_DIR" 2>/dev/null || echo "No matches for '$pattern'"
  echo
done

echo "[+] Search complete."

#!/bin/bash
#
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
#
#

error_log() {
  echo "${1}" 1>&2;
}

usage() {
  echo "${0}: Generate MLZ resource names"
  error_log "usage: ${0} <enclave name> <sub id>"
}

if [[ "$#" -ne 2 ]]; then
   usage
   exit 1
fi

mlz_enclave_name_raw=$1
mlz_laws_sub_id_raw=$2

safe_sub_id=

# remove hyphens for resource naming restrictions
# in the future, do more cleansing
mlz_enclave_name="${mlz_enclave_name_raw//-}"

# Name MLZ config resources
export mlz_laws_sub_id="${mlz_laws_sub_id_raw//-}"
export mlz_laws_rg_name="rg-mlz-laws-${mlz_enclave_name}"
export mlz_laws_prefix="laws-${mlz_enclave_name}"
export mlz_laws_workspacename="${mlz_laws_prefix}-${mlz_laws_sub_id}"
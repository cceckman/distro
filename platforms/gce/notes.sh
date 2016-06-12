#!/bin/sh
# Google Compute Engine hooks.
declare -a HOOKS

HOOKS[${#HOOKS}]="image"

image() {
    # The equivalent of "install the image on disk":
    # set up a VM in the currently-configured project.
    # I *think* this works.
    # TODO add prompt hook
    gcloud auth login
    gcloud config set project cceckman-dev
    name="arch-c2"
    gcloud compute \
        --project "cceckman-dev" \
        instances create "$name" \
        --description "Arch version of the image." \
        --zone "us-east1-d" \
        --machine-type "g1-small" \
        --image-project "cceckman-dev" \
        --image "arch-v20151203" \
        --boot-disk-type "pd-standard" \
        --boot-disk-device-name "$name"
}

. ../platform-common.sh

#/bin/bash

# Create the GCloud Authentication file if set
if [ ! -z "$GCP_GCLOUD_AUTH" ]
then
    echo "$GCP_GCLOUD_AUTH" | base64 --decode > "$HOME"/gcloud.json
    gcloud auth activate-service-account --key-file=$HOME/gcloud.json
fi


#backup filestore to GCS

DATE=$(date +"%m-%d-%Y-%T")

mkdir -p /mnt/$FILESHARE_MOUNT_PRIMARY
mount $FILESTORE_IP_PRIMARY:/$FILESHARE_NAME_PRIMARY /mnt/$FILESHARE_MOUNT_PRIMARY

gsutil rsync -r /mnt/$FILESHARE_MOUNT_PRIMARY/ gs://$GCP_BUCKET_NAME/$DATE/


#rsync filestore to secondary region

mkdir -p /mnt/$FILESHARE_MOUNT_SECONDARY
mount $FILESTORE_IP_SECONDARY:/$FILESHARE_NAME_SECONDARY /mnt/$FILESHARE_MOUNT_SECONDARY

rsync -avz /mnt/$FILESHARE_MOUNT_PRIMARY/ /mnt/$FILESHARE_MOUNT_SECONDARY/

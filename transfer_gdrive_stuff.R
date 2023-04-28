# reassign owner for things I am the owner on.
# Note that you should probably warn the new owner that you 
# are doing this, as they'll get many emails...one way to deal with this is to 
# create an email filter. The sendNotificationEmail = FALSE may prevent this?

1
# loop through the files (just copy/paste in new paths to drive_ls, could try to automate this in the 
#future). However, there are some files that cause the api to fail, so doing a 
# huge group of files at once may not pay off (at least at this stage of the code)

test <- googledrive::drive_ls("https://drive.google.com/drive/u/0/folders/11N_SRCHdVXp7awAYkBI0TgqvS-LuVkl_", recursive = TRUE)

# filter by which ones are owned by me
owned_by_me <- unlist(lapply(test$drive_resource, function(x) x$ownedByMe))
files_owned_by_me <- test[owned_by_me,]
to_rm <- grep("shortcut", unlist(lapply(files_owned_by_me$drive_resource, function(x) x$mimeType)))
if(length(to_rm) > 0) {
  files_to_change <- files_owned_by_me[-to_rm,]
} else {
  files_to_change <- files_owned_by_me
}

# reassign those to GGT.
drive_share(as_id(files_to_change$id), role = "owner", type = "user", 
            emailAddress = "github.governance.team@noaa.gov", transferOwnership = TRUE 
)
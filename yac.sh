#!/bin/bash

# **********************************
# yac.sh v0.02
# YellowAutomaticContent
# Script from: 02.02.2024
#
# This script automatically creates content
# for the Yellow CMS Blog. 
# The images will be downloaded from unsplash.
#
# How to use.
# All details you find below.
# 1. copy the file »yac.sh« into your blog folder (content/2-blog).
# 2. open the file »yac.sh« with a code editor.
# 3. make your settings.
# 4. start the file with »bash yac.sh« in a terminal.
# have fun!
#
# https://github.com/PetersOtto/YellowAutomaticContent
# https://github.com/datenstrom
# https://unsplash.com
# **********************************

# ******************
# Enter parameters *
# ******************

# ***************************
# Create posts with images? *
# YES or NO
# ***************************
downloadImages="YES"

# ********************************
# Enter parameters for the posts *
# ********************************

# How many posts should be created? 
numberPost=2

# Name of the blog. (e.g. blog, projects, career ...)
# Only one Word!
blogName="Blogpost"

# At what interval should backdating take place? 
#timeJump="year"
timeJump="month"
#timeJump="day"
#timeJump="hour"

# Which tags should be used? 
tagOne="Tag one"
tagTwo="Tag two"
tagThree="Tag tree"

# Content of the page
moreContent="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna pizza. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. [--more--]

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna pizza. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

# ********************************
# Enter parameters for the images *
# ********************************

# Choose the download folder
#imageDownloadFolder="NO" # Same storage location as the posts.
imageDownloadFolder="../../media/images/" # Default location for images. Script location is »content/your-blog-folder«

# Choose picture theme
theme='buildings'

# Number of images to be downloaded from Unsplash.
numberImages=$numberPost

# In which formats should the images be downloaded?
# YES or NO
landscapeFormat='YES'
portraitFormat='YES'

# What image format should the images have?
# 16/9, 4/3 ...
minimumWidth=600 # px
longSideFactor=16
shortSideFactor=9

# ********************
# Start part »Posts« *
# ********************

clear

echo ""
echo "**************"
echo "* Here we go *"
echo "**************"
echo ""
echo "****************"
echo "* Create posts *"
echo "****************"
echo ""
sleep 1

blogNameLow=${blogName,,}

i=0
while [ $i -lt $numberPost ]; do

	randomTagNo=$((1 + RANDOM % 3))
    if [ $randomTagNo == 1 ]
    then
        tag=$tagOne
    fi

    if [ $randomTagNo == 2 ]
    then
        tag=$tagTwo
    fi

    if [ $randomTagNo == 3 ]
    then
        tag=$tagTwo
    fi

	ni=$(printf "%03d" "$i")
	echo ""
	echo "Create posts No. $ni" 
	newDateHeader=$(date -d "- $i $timeJump" "+%Y-%m-%d %H:%M:%S")
	newDateFile=$(date -d "- $i $timeJump" "+%Y-%m-%d")
	
	header="---
Title: $blogName No.$ni
Published: $newDateHeader
Author: Your Name
Layout: blog
Tag: $tag
---"
	content="
## This is $blogName No.$ni

[image $ni-unsplash.jpg]

$moreContent"

	filename="$newDateFile-$blogNameLow-$ni"
	
	cat <<-EoF > $filename.md
	$header
	$content
	EoF
	echo $filename.md was created.
				
	i=$[$i+1]; 
done

echo ""
echo "***************************"
echo "* Finished creating posts *"
echo "***************************"
echo ""
sleep 1


# *********************
# Start part »Images« *
# *********************

if [ "$downloadImages" == "YES" ]
	then

    echo ""
    echo "*********************"
    echo "* Download images  *"
    echo "*********************"
    echo ""
    sleep 2

    # Calculate resolution
    heightLandscapeFormat=$((($minimumWidth*$shortSideFactor)/($longSideFactor)))
    heightPortraitFormat=$((($minimumWidth*$longSideFactor)/($shortSideFactor)))

    i=0
    while [ $i -lt $numberImages ]; do
        if [ "$landscapeFormat" == "YES" ]
        then
            ni=$(printf "%03d" "$i")
            echo "Download image No. $ni - landscape with the resolution ${minimumWidth}px x ${heightLandscapeFormat}px ($longSideFactor zu $shortSideFactor) - theme: »$theme«" 
            wget -q -O $ni-unsplash.jpg https://source.unsplash.com/random/${minimumWidth}x${heightLandscapeFormat}/?$theme
            if [ "$imageDownloadFolder" != "NO" ]
            then
                mv $ni-unsplash.jpg $imageDownloadFolder
            fi
        fi
        
        if [ "$portraitFormat" == "YES" ] && [ "$landscapeFormat" == "YES" ]
        then
            i=$[$i+1];
        fi	
        
        if [ "$portraitFormat" == "YES" ]
        then	
            ni=$(printf "%03d" "$i") 
            echo "Download image No. $ni - portrait with the resolution ${minimumWidth}px x ${heightPortraitFormat}px ($shortSideFactor zu $longSideFactor) - theme: »$theme«"
            wget -q -O $ni-unsplash.jpg https://source.unsplash.com/random/${minimumWidth}x${heightPortraitFormat}/?$theme
            if [ "$imageDownloadFolder" != "NO" ]
            then
                mv $ni-unsplash.jpg $imageDownloadFolder
            fi
        fi
            
        i=$[$i+1]; 
    done

    echo ""
    echo "*******************************"
    echo "* Finished downloading images *"
    echo "*******************************"
    echo ""
    sleep 2
fi

exit 0

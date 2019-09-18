#!/bin/bash

# source version info
function source_version_info {
    if [ -f VERSION ]; then
        . ./VERSION
    else
        echo "No VERSION-File, exit!"
        exit 1
    fi
}


# eventually cleanup old builds
function cleanup_old_builds {
    if [ -f ./debian/rules ]; then
        debclean -d
        rm debian/rules
        echo "old builds cleaned up, run bootstrap again!"
        return 1
    fi
}


# debian cleanup
# ==============
function debian_cleanup {
    rm -vrf debian/siduction-live-settings-*-*
    rm -vrf debian/siduction-settings-*-*
    rm -vf debian/files
    rm -vf debian/*.init
    rm -vf debian/*.install
    rm -vf debian/*.lintian-overrides
    rm -vf debian/*.log
    rm -vf debian/*.postinst
    rm -vf debian/*.preinst
    rm -vf debian/*.postrm
    rm -vf debian/*.service
}


# debian changelog
# ================
function debian_changelog {
    if [ ! -f debian/changelog ]; then
        sed -e "s/\@CODENAME_SAFE\@/${CODENAME_SAFE}/g" \
            -e "s/\@CODENAME\@/${CODENAME}/g" \
            -e "s/\@DISTRIBUTION\@/${DISTRIBUTION}/g" \
            -e "s/\@VERSION\@/${VERSION}/g" \
            ../template/debian/changelog \
            > ./debian/changelog
    fi
}


# basic control
# =============
function basic_control {
    sed -e "s/\@CODENAME_SAFE\@/${CODENAME_SAFE}/g" \
        -e "s/\@CODENAME\@/${CODENAME}/g" \
        -e "s/\@DISTRIBUTION\@/${DISTRIBUTION}/g" \
        -e "s/\@VERSION\@/${VERSION}/g" \
        ../template/debian/control \
        > ./debian/control
}


# grub template
# =============
function grub_template {
    mkdir -p ./etc/default/grub.d
    sed -e "s/\@CODENAME_SAFE\@/${CODENAME_SAFE}/g" \
        -e "s/\@CODENAME\@/${CODENAME}/g" \
        -e "s/\@DISTRIBUTION\@/${DISTRIBUTION}/g" \
        -e "s/\@VERSION\@/${VERSION}/g" \
        ../template/etc/default/grub.d/siduction.cfg \
        > ./etc/default/grub.d/siduction.cfg
}


# debian rules
# ============
function debian_rules {
    sed -e "s/\@CODENAME_SAFE\@/${CODENAME_SAFE}/g" \
        -e "s/\@CODENAME\@/${CODENAME}/g" \
        -e "s/\@DISTRIBUTION\@/${DISTRIBUTION}/g" \
        -e "s/\@VERSION\@/${VERSION}/g" \
        ../template/debian/rules \
        > ./debian/rules
    chmod 755 debian/rules
}


# debian_foo_basics
# =================
function debian_foo_basics {
    mkdir -p ./debian/source
    cp -av ../template/debian/source/format ./debian/source/
    cp -av ../template/debian/source/options ./debian/source/
}

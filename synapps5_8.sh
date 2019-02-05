#!/bin/bash

wget https://www.aps.anl.gov/files/APS-Uploads/BCDA/synApps/tar/synApps_5_8.tar.gz

tar -xzf synApps_5_8.tar.gz
rm synApps_5_8.tar.gz

mv synApps_5_8 /usr/local/epics

# install libsz2 and hdf5
wget https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz
tar -xzf szip-2.1.1.tar.gz
cd szip-2.1.1
./configure --prefix=/usr/local/epics/szip
make
make check
make install

cd ..
rm -rf szip-2.1.1
rm szip-2.1.1.tar.gz


wget https://support.hdfgroup.org/ftp/HDF5/current18/src/hdf5-1.8.20.tar.gz
tar -xzf hdf5-1.8.20.tar.gz
cd hdf5-1.8.20
./configure --prefix=/usr/local/epics/hdf5
make
make test
make install

cd ..
rm -rf hdf5-1.8.20
rm hdf5-1.8.20.tar.gz 

# fix paths

find /usr/local/epics/synApps_5_8 -type f -name "RELEASE" -exec sed -i 's/SUPPORT=\/home\/oxygen\/MOONEY\/distrib\/synApps_5_8\/support/SUPPORT=\/usr\/local\/epics\/synApps_5_8\/support/g; s/EPICS_BASE=\/home\/oxygen\/MOONEY\/epics\/bazaar\/base-3.15/EPICS_BASE=\/usr\/local\/epics\/base/g' {} +

sed -i '283s/^/\/\/ /; 284s/^/\/\/ /' /usr/local/epics/synApps_5_8/support/caputRecorder-1-4-2/caputRecorderApp/src/caputRecorder.c

sed -i 's/^/# /' /usr/local/epics/synApps_5_8/support/devIocStats-3-1-13/RELEASE_SITE

echo 'MODULES_SITE_TOP=/usr/lib/local/modules' >> /usr/local/epics/synApps_5_8/support/devIocStats-3-1-13/RELEASE_SITE


sed -i 's:HDF5         = /APSshare/linux/x86_64/libHDF5:HDF5         = /usr/local/epics/hdf5:; s:SZIP           = /APSshare/linux/x86_64/libSZIP:SZIP           = /usr/local/epics/szip:' /usr/local/epics/synApps_5_8/support/areaDetector-R2-0/configure/CONFIG_SITE.local.linux-x86_64



find /usr/local/epics/synApps_5_8 -type f | xargs grep -l "MSI=" | xargs -i@ sed -i '/MSI=/c\MSI=\/usr\/bin\/msi' @

# fix hardening -- begin

sed -i 's/errlogPrintf(SR_recentlyStr);/errlogPrintf("%s", SR_recentlyStr);/'  /usr/local/epics/synApps_5_8/support/autosave-5-6-1/asApp/src/save_restore.c

sed -i 's/printf(cur->name);/printf("%s", cur->name);/'  /usr/local/epics/synApps_5_8/support/sscan-2-10-1/sscanApp/src/saveData.c

sed -i 's/cantProceed(msg);/cantProceed("%s", msg);/'  /usr/local/epics/synApps_5_8/support/asyn-4-26/asyn/asynDriver/epicsInterruptibleSyscall.c

sed -i 's/sprintf(tmpstr, ps->s);/sprintf("%s", tmpstr, ps->s);/'  /usr/local/epics/synApps_5_8/support/calc-3-4-2-1/calcApp/src/sCalcPerform.c

sed -i 's/#=============================/#=============================\nUSR_CFLAGS="-Wno-error=format-security"/'  /usr/local/epics/synApps_5_8/support/optics-2-9-3/opticsApp/src/Makefile

sed -i 's/printf(hytecstr);/printf("%s", hytecstr);/'  /usr/local/epics/synApps_5_8/support/motor-6-9/motorApp/HytecSrc/HytecMotorDriver.cpp

sed -i 's/cantProceed(functionName);/cantProceed("%s", functionName);/'  /usr/local/epics/synApps_5_8/support/areaDetector-R2-0/ADCore-R2-2/ADApp/pluginSrc/NDPluginROIStat.cpp


sed -i 's/fprintf(fp, section);/fprintf(fp, "%s", section);/'  /usr/local/epics/synApps_5_8/support/dxp-3-4/dxpApp/handelSrc/fdd.c


sed -i 's/fprintf(fp, section);/fprintf(fp, "%s", section);/'  /usr/local/epics/synApps_5_8/support/dxp-3-4/dxpApp/handelSrc/fdd.c

# fix hardening -- end


cd /usr/local/epics/synApps_5_8/support && make release
cd /usr/local/epics/synApps_5_8/support && make

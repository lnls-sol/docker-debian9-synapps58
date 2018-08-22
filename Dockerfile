FROM lnlssol/debian9-epicsbase
# Install dependecies
RUN apt-get update
RUN apt-get install libsz2 hdf5-tools libhdf5-dev libtiff5-dev libxml2-dev re2c wget make gcc g++ -y
# Install extensions
COPY extensions.sh .
RUN ./extensions.sh && rm extensions.sh
# Install SynApps
COPY synapps5_8.sh .
RUN ./synapps5_8.sh && rm synapps5_8.sh
CMD bash

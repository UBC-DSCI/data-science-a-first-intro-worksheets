# Copyright (c) UBC-DSCI Development Team.
FROM ubcdsci/r-dsci-100:20230724142640d8f06f

# Make sure the contents of our repo are in ${HOME} for binder
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

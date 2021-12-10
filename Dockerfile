# Copyright (c) UBC-DSCI Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/r-notebook:notebook-6.4.3

LABEL maintainer="Tiffany Timbers <tiffany.timbers@gmail.com>"

# Install R packages on conda-forge
RUN conda install --quiet --yes -c conda-forge \
  r-cowplot=1.1.* \
  r-ggally=2.1.* \
  r-gridextra=2.3 \
  r-infer=0.5.* \
  r-kknn=1.3.* \
  r-rpostgres=1.3.*

# we can't use testthat 2.3 because of weird "no testthat_print" function error https://github.com/r-lib/rlang/issues/1112
# we can't use testthat 3.0.4 (current release) because it doesn't include the fix to make interactive tests error https://github.com/r-lib/testthat/pull/1443
# so we will install testthat from a specific commit hash
# old code to do 2.3.2 : RUN Rscript -e "devtools::install_version('testthat', version = '2.3.2', repos = 'http://cran.us.r-project.org')"
RUN Rscript -e "remotes::install_github('r-lib/testthat@4fcc0c7152704c5c2049441920d78d9dfe448836')"

# Install the palmerpenguins dataset
RUN Rscript -e "devtools::install_github('allisonhorst/palmerpenguins@v0.1.0')" 

# Install ISLR package for the Credit data set
RUN Rscript -e "install.packages('ISLR', repos='http://cran.us.r-project.org')"

RUN pip install --no-cache-dir vdom==0.5

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

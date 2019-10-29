FROM rocker/tidyverse:devel
ENV PATH=$PATH:/opt/TinyTeX/bin/x86_64-linux/

## Add LaTeX, rticles and bookdown support
RUN wget "https://travis-bin.yihui.name/texlive-local.deb" \
  && dpkg -i texlive-local.deb \
  && rm texlive-local.deb \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ## for rJava
    default-jdk \
    ## Nice Google fonts
    fonts-roboto \
    ## used by some base R plots
    ghostscript \
    ## used to build rJava and other packages
    libbz2-dev \
    libicu-dev \
    liblzma-dev \
    ## system dependency of hunspell (devtools)
    libhunspell-dev \
    ## system dependency of hadley/pkgdown
    libmagick++-dev \
    ## rdf, for redland / linked data
    librdf0-dev \
    ## for V8-based javascript wrappers
    libv8-dev \
    ## R CMD Check wants qpdf to check pdf sizes, or throws a Warning
    qpdf \
    ## For building PDF manuals
    texinfo \
    ## for git via ssh key
    ssh \
 ## just because
    less \
    vim \
 ## parallelization
    libzmq3-dev \
    libopenmpi-dev \
 && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  ## Use tinytex for LaTeX installation
  && install2.r --error tinytex \
 ## Admin-based install of TinyTeX:
  && wget -qO- \
    "https://github.com/yihui/tinytex/raw/master/tools/install-unx.sh" | \
    sh -s - --admin --no-path \
  && mv ~/.TinyTeX /opt/TinyTeX \
  && /opt/TinyTeX/bin/*/tlmgr path add \
  && tlmgr install ae inconsolata listings metafont mfware parskip pdfcrop tex \
  && tlmgr path add \
  && Rscript -e "tinytex::r_texmf()" \
  && chown -R root:staff /opt/TinyTeX \
  && chown -R root:staff /usr/local/lib/R/site-library \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin \
  && echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron \
  ## Currently (2017-06-06) need devel PKI for ssl issue: https://github.com/s-u/PKI/issues/19
  && install2.r --error PKI \
  ## And some nice R packages for publishing-related stuff
  && install2.r --error --deps TRUE \
    bookdown rticles rmdshower rJava
#
## Consider including:
# - yihui/printr R package (when released to CRAN)
# - libgsl0-dev (GSL math library depend

# Install R Packages
RUN R -e "install.packages(c('data.table','tidyverse','dplyr','extrafont','testthat','readr','ggplot2','shape','graphics','scales','rmarkdown','readxl','stringr','gridExtra','cowplot','devtools','patchwork','RColorBrewer','grid','showtext','ggrepel','knitr','magrittr','tools','officer','mschart','flextable'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

# RUN R -e "install.packages('data.table',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('tidyverse',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('dplyr',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('extrafont',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('testthat',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('readr',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('ggplot2',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('shape',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('graphics',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('scales',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('rmarkdown',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('readxl',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('stringr',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('gridExtra',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('cowplot',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('devtools',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('patchwork',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('RColorBrewer',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('grid',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('showtext',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('ggrepel',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('knitr',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('magrittr',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('tools',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('officer',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('mschart',dependencies=TRUE, repos='http://cran.rstudio.com/')"
# RUN R -e "install.packages('flextable',dependencies=TRUE, repos='http://cran.rstudio.com/')"

# CMD ["bash"]
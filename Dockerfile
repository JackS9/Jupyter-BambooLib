FROM jupyter/scipy-notebook:1386e2046833

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

COPY requirements.txt /tmp/
RUN conda install --yes --file /tmp/requirements.txt && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER
    
USER root

COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}

RUN pip install 'bamboolib>=0.1.1'
RUN jupyter nbextension enable --py qgrid --sys-prefix && \
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    jupyter nbextension install --py bamboolib --sys-prefix && \
    jupyter nbextension enable --py bamboolib --sys-prefix

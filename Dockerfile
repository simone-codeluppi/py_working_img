# Install the anaconda environment
FROM continuumio/anaconda3

# Add some metadata to the image        
LABEL maintainer="simone.codeluppi@gmail.com"
LABEL version='1.0'
LABEL description=" This image is used to set up my working anaconda environment \
        with multiple environments"

# Update and upgrade system
# RUN apt-get update
# RUN apt-get upgrade -y

# Install some system utilities
RUN apt-get install -y apt-utils
RUN apt-get install -y vim
RUN apt-get install -y gcc 
RUN apt-get install -y mpich
RUN apt-get install -y tmux

# Update conda and anaconda
RUN  ["/bin/bash", "-c", "conda update -n base conda && conda update anaconda"]

# Update pip
RUN ["/bin/bash", "-c","pip install --upgrade pip"]

# Create the pysmFISH_testing_env
RUN ["/bin/bash", "-c", "conda create --name pysmFISH_testing_env python=3.6 h5py numpy scipy scikit-image pandas"]
RUN ["/bin/bash", "-c", "source activate pysmFISH_testing_env"]
RUN ["/bin/bash", "-c", "conda install -c conda-forge scipy dask distributed scikit-learn jupyterlab nodejs ipympl"]
RUN ["/bin/bash", "-c", "pip install nd2reader==2.1.3 sympy ruamel.yaml mpi4py loompy sphinx sphinx_rtd_theme"]


# Add the kernel of the pysmFISH_testing_env to the jupyter lab
RUN ["/bin/bash", "-c", "/opt/conda/envs/pysmFISH_testing_env/bin/python -m pip install ipykernel"]
RUN ["/bin/bash", "-c", "python -m ipykernel install --user --name pysmFISH_testing_env --display-name 'pysmFISH_testing_env'"]

# Install extension for matplotlib in jupyter lab
RUN ["/bin/bash", "-c", "jupyter labextension install @jupyter-widgets/jupyterlab-manager"]

# Create the datashader env 
RUN ["/bin/bash", "-c", "conda create --name datashader_env python=3.6 h5py scikit-image"]
# RUN ["/bin/bash", "-c", "conda install -c conda-forge jupyterlab nodejs ipympl"]
RUN ["/bin/bash", "-c","source activate datashader_env"]
RUN ["/bin/bash", "-c", "conda install -c bokeh/label/dev datashader"]
RUN ["/bin/bash", "-c", "conda install -c ioam/label/dev holoviews"]
RUN ["/bin/bash", "-c","node /opt/conda/envs/datashader_env/lib/python3.5/site-packages/jupyterlab/staging/yarn.js install"]
# Add kernel to jupyter lab
RUN ["/bin/bash", "-c", "/opt/conda/envs/datashader_env/bin/python -m pip install ipykernel"]
RUN ["/bin/bash", "-c", "python -m ipykernel install --user --name datashader_env --display-name 'datashader_env'"]

# Create the Mask R-CNN network
RUN ["/bin/bash", "-c", "conda create --name RCNN_env python=3.6"]
RUN ["/bin/bash", "-c","source activate RCNN_env"]
# Install Tensorflow with support for CPU
RUN ["/bin/bash", "-c", "pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.6.0-cp36-cp36m-linux_x86_64.whl"]
RUN ["/bin/bash", "-c","pip install h5py graphviz pydot keras Cython pycocotools scikit-image"]
# Add kernel to jupyter lab
RUN ["/bin/bash", "-c", "/opt/conda/envs/RCNN_env/bin/python -m pip install ipykernel"]
RUN ["/bin/bash", "-c", "python -m ipykernel install --user --name datashader_env --display-name 'RCNN_env'"]



# Add some useful commands to ~/.bashrc
RUN chmod 777 ~/.bashrc && echo 'alias jl="jupyter lab --port=8080 --ip=0.0.0.0 --no-browser --allow-root"'>> ~/.bashrc




# List the available conda envs
# Exposing ports
EXPOSE 8080 3000

# Decide what to do with Entry and CMD

# Environment start in pysmFISH environment
# ENTRYPOINT [ "source",'activate','pysmFISH_testing_env' ]

# Run jupyter lab on the exposed port if no command is passed
# CMD ["/bin/bash", "-c","conda info --envs"]

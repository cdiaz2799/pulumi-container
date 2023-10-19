FROM pulumi/pulumi-python:latest

# Setup Vars
ENV DEBIAN_FRONTEND=noninteractive
ENV VIRTUAL_ENV=/pulumi/projects/venv

# Install Apt Packages
RUN apt-get install -yf gpg \
  && curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
  && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
  && apt-get update \
  && apt-get upgrade -yf \
  && apt-get install -y kubectl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Setup Python PIP
RUN mkdir $HOME/.kube/
RUN mkdir -p ${VIRTUAL_ENV} 
RUN python3 -m venv ${VIRTUAL_ENV}
RUN $VIRTUAL_ENV/bin/pip install --no-color --upgrade pip
RUN $VIRTUAL_ENV/bin/pip install --no-color --upgrade virtualenv
RUN $VIRTUAL_ENV/bin/pip install --no-color --upgrade setuptools
COPY requirements.txt requirements.txt
RUN $VIRTUAL_ENV/bin/pip install --no-color --upgrade -r requirements.txt

WORKDIR /pulumi/projects
CMD [ "pulumi version" ]
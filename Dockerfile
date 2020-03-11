FROM gitlab/gitlab-runner

ENV TF_VERSION=0.12.23

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Terraform
ENV TF_FILE=terraform_${TF_VERSION}_linux_amd64.zip
RUN apt-get install unzip
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_FILE}
RUN unzip ${TF_FILE}
RUN rm ${TF_FILE}
RUN mv terraform /usr/local/bin

# Install Ansible
RUN apt-get install -y software-properties-common
RUN apt-add-repository --yes --update ppa:ansible/ansible
RUN apt-get install -y ansible

COPY ./register-run.sh .
RUN chmod 0555 ./register-run.sh

ENTRYPOINT ["/bin/bash"]
CMD [ "./register-run.sh" ]
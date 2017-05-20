FROM slafs/python-ubuntu:2.7-wily

MAINTAINER PanJ

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
RUN apt-get update --fix-missing
RUN apt-get install -y cron mongodb-org-tools mongodb-org-shell
RUN pip install awscli
RUN service cron start

ADD ./backup.sh /mongodb-s3-backup/backup.sh
ADD ./cron-setup.sh /mongodb-s3-backup/cron-setup.sh
WORKDIR /mongodb-s3-backup
RUN chmod +x /mongodb-s3-backup/backup.sh
RUN chmod +x /mongodb-s3-backup/cron-setup.sh

ENTRYPOINT ["/bin/sh"]
CMD ["./cron-setup.sh"]

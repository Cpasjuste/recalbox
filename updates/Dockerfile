FROM nginx:1.13.3

ADD dist/ /usr/share/nginx/html/
ADD v1/noobs /usr/share/nginx/html/v1/noobs

# archive.recalbox.com compatibily. To remove after all recalbox in 4.1.0
ADD archive-compatibility.sh /usr/local/bin/
RUN /usr/local/bin/archive-compatibility.sh

# noobs compatibily
ADD noobs-compatibility.sh /usr/local/bin/
RUN /usr/local/bin/noobs-compatibility.sh

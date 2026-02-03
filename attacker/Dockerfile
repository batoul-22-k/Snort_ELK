FROM kalilinux/kali-rolling

RUN apt-get update  && apt-get install -y --no-install-recommends nmap hping3 slowloris netcat-traditional iproute2 procps curl wget  && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]

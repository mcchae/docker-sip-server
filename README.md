# SIP 서버 for docker container

이 컨테이너는 asterisk 서버를 이용한 SIP 서비스를 구성합니다.

## 사용법
docker-compose 설정 파일로 다음과 같이 설정합니다.

```yaml
version: '2'

services:
  asterisk:
    image: mcchae/sip-server
    container_name: sip_server
    ports:
      - "192.168.100.10:5060:5060/udp"
      - "192.168.100.10:5060:5060/tcp"
      - "192.168.100.10:10000-10099:10000-10099/udp"
      - "192.168.100.10:8088:8088"
      - "192.168.100.10:8089:8089"
    volumes:
      - "./var/conf/msmtprc:/etc/msmtprc"
      - "./var/conf/asterisk:/etc/asterisk"
      - "./var/data/asterisk:/var/lib/asterisk"
      - "./var/data/asterisk-spool:/var/spool/asterisk"
      - "./var/ssl:/ssl"
    # tcpdump -i any -nn udp
  siptest:
    image: ubuntu
    container_name: sip_client
    links:
      - sip
    command: /bin/sleep 1000
    # apt update && apt install -y iputils-ping ...
    # ...
```

* siptest 는 테스트용 컨테이너

## 테스트


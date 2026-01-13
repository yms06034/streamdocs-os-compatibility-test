# Use existing rocky-9.6-minimal and update EXPOSE
FROM rocky-9.6-minimal:latest

EXPOSE 8080 8888

CMD ["/bin/bash"]

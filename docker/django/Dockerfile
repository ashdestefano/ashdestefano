# Use an official Python runtime as a parent image
FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]

# Set environment varibles
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt update
RUN apt install -y python3-venv python3-dev python3-pip libpq-dev nginx curl ncat
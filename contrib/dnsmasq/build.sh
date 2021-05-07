#!/usr/bin/env bash
PROJECT_ID=$(gcloud info --format='value(config.project)')
gcloud builds submit --tag=gcr.io/${PROJECT_ID}/dnsmasq:0.1
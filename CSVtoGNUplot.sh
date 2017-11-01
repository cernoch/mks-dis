#!/bin/bash
{
    read # Remove the CSV header
    cat  # Pipe the rest
} | grep -i $1\
  | cut -d';' -f $2 --output-delimiter=" "\
  | grep -v '\?'
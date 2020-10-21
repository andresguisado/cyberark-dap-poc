#!/bin/bash

#Delete Conjur Resources
conjur policy load --delete root delete-resources.yml

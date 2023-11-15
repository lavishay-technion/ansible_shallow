#!/usr/bin/env python3

import argparse
import logging

try:
   import json
except ImportError:
   import simplejson as json

class Inventory:
    def __init__(self, include_hostvars_in_list):

        self.configure_logger()

        self.include_hostvars_in_list = include_hostvars_in_list

        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action='store_true', help='list inventory')
        parser.add_argument('--host', action='store', help='show HOST variables')
        self.args = parser.parse_args()

        if self.include_hostvars_in_list:
            merged = self.groups
            merged['_meta'] = {}
            merged['_meta']['hostvars'] = self.hostvars
        else:
            return self.groups

        if not (self.args.list or self.args.host):
            parser.print_usage()
            raise SystemExit
        
        self.define_inventory()

        if self.args.list:
            self.print_json(self.list())
        elif self.args.host:
            self.print_json(self.host())

    def define_inventory(self):
        self.groups = {
				"db": {
					"hosts": ['node2', 'node4'],
					"vars":{
                        "ansible_user": 'root'
					}
				},
				"ansible_host":{
					"hosts": ["ansible_host"]
				},
				"web":{
					"hosts": ['node1', 'node3'],
					"vars":{
						"ansible_become":True,
						"ansible_become_pass": 'P@$$w0rd'
					}
				},
				"multi": {
                    "children": ["db", "web"]
				}
			}

    def configure_logger(self):
        self.logger = logging.getLogger('ansible_dynamic_inventory')
        self.hdlr = logging.FileHandler('/var/tmp/ansible_dynamic_inventory.log')
        self.formatter = logging.Formatter('%{asctime}s %(levelname) %(messages)')
        self.hdlr.setFormatter(self.formatter)
        self.logger.addHandler(self.hdlr)
        self.logger.setLevel(logging.DEBUG)

    def print_json(self,content):
        print(json.dumps(content,indent=4,sort_keys=True))

    def list(self):

        if self.include_hostvars_in_list:
            merged = self.groups
            merged['_meta'] = {}
            merged['_meta']['hostvars'] = self.hostvars
            return merged
        else:
            return self.groups
    
    def host(self):
        if self.args.host in self.hostvars:
            return self.hostvars[self.args.host]
        else:
            return {}

Inventory(include_hostvars_in_list=False)


#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Master IP here
Master_IP_Address=your.master.ip.here
Work_Path=`dirname "$0"`
cd ~
if [ -e /usr/bin/ssh ]; then
  echo "checking ssh ... found"
else
  echo "pleash instsll \"ssh\""
  exit
fi

if [ -e /usr/sbin/sshd ]; then
  echo "checking sshd ... found"
else
  echo "pleash instsll \"sshd\""
  exit
fi
mkdir crawlzilla_slave_install
scp -r -o StrictHostKeyChecking=no crawler@$Master_IP_Address:/home/crawler/crawlzilla/source/* crawlzilla_slave_install/.
exec crawlzilla_slave_install/slave_install

#!/usr/bin/env python3
#------------------------------------------------------------IMPORT MODULES
#Version 0.1, written by jimmygiv/mr_sudo
#Description: Control a "time schedule" for your linux distro. Could you use crontabs?
#    Sure, but where's the python fun in that.
from time import time,sleep
from datetime import datetime,timedelta
from subprocess import Popen,PIPE

#------------------------------------------------------------DEFINE SCHEDULE
#Time used is in GMT
WEEKDAY_START='wednesday'
WEEKDAY_END='saturday'
HOUR_START=11
HOUR_END=22

#Get ranges from defined schedule
d = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
try:
  WEEKDAY_S = list( int(x) for x in range( len(d) ) if d[x]==WEEKDAY_START)[0]
  WEEKDAY_E = list( int(x) for x in range( len(d) ) if d[x]==WEEKDAY_END)[0]
  WEEK_RANGE = range(WEEKDAY_S, WEEKDAY_E+1)
  HOUR_RANGE = range(HOUR_START, HOUR_END+1)
except:
  exit()


#------------------------------------------------------------DEFINE CLASS
class Control:

  def __init__(self):
    self.day, self.hour = self.gettime()
    
  def gettime(self):
    return datetime.today().weekday(), datetime.today().hour
  
  def msg(self, text):
      self.text = text
      cmd = ("wall " + self.text).split()
      p = Popen(cmd, stdout=PIPE, stderr=PIPE)
      out = p.communicate()[0]
      return bool(out)
 
  def shutdown(self):
     p = Popen(['shutdown'], stdout=PIPE, stderr=PIPE)
     out = p.communicate()[0]
     return bool(out)
   
  def sleeper(self, t):
      self.t = t
      self.future = datetime(t.year,t.month,t.day,t.hour+1,0)
      self.s = (self.future-self.t).seconds
      #print(f'Sleeping until: {self.s}')
      sleep(self.s)
      
#------------------------------------------------------------DEFINE MAIN
def main(WEEK_RANGE, HOUR_RANGE):
  c = Control()
  if c.day in WEEK_RANGE:
    
    if c.hour not in HOUR_RANGE: 
      c.msg("Outside work hours. Powering down.")
      c.shutdown()
        
    else:
      t = datetime.today()
      c.sleeper( t )
    
  else: 
    c.msg("Outside work hours. Powering down.")
    c.shutdown()

#------------------------------------------------------------RUN
while True:
   main(WEEK_RANGE, HOUR_RANGE)

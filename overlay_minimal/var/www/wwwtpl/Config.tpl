Content-type: text/html

<!DOCTYPE html>
<html lang='en' class=''>
  <head>
    <title>$HOSTNAME YaCAM Setup</title>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width,initial-scale=1,user-scalable=no'/>
    <style>div,fieldset,input,select{padding:5px;font-size:1em;}fieldset{background:#f2f2f2;}p{margin:0.5em 0;}input{width:100%;box-sizing:border-box;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;background:#ffffff;color:#000000;}input[type=checkbox],input[type=radio]{width:1em;margin-right:6px;vertical-align:-1px;}select{width:100%;backgroud:#ffffff;color:#000000;}textarea{resize:none;width:98%;height:318px;padding:5px;overflow:auto;background:#ffffff;color:#000000;}body{text-align:center;font-family:verdana,sans-serif;background:#ffffff;}td{padding:0px;}button{border:0;border-radius:0.3rem;background:#1fa3ec;color:#ffffff;line-height:2.4rem;font-size:1.2rem;width:100%;-webkit-transition-duration:0.4s;transition-duration:0.4s;cursor:pointer;}button:hover{background:#0e70a4;}.bred{background:#d43535;}.bred:hover{background:#931f1f;}.bgrn{background:#47c266;}.bgrn:hover{background:#5aaf6f;}a{text-decoration:none;}.p{float:left;text1float:right;text-align:right;}</style>
  </head>
  <body>
    <div style='text-align:left;display:inline-block;color:#000000;min-width:340px;'>
      <h1>$HOSTNAME YaCAM Setup</h1>
      <p>Git Version: $GITVERSION<p>
      <p>Version: $VERSION<p>
      <p>Build date: $BUILDDATE<p>
      <p>MAC Address: $MAC<p>
      <p><a href="/cgi-bin/firmware">Firmware update</a></p>
      <div></div>
      <p></p>
        <form action='/cgi-bin/configsave' method='POST'>
          <h2>Set YaCAM parameters</h2>
          <div></div>
          <table style='width:100%'>
            <tr>
              <td style='white-space:nowrap;align:left'><h3>Network Settings</h3></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Hostname:</td>
              <td><input type='text' name='NHOSTNAME' value='$HOSTNAME' placeholder=''></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Wifi SSID:</td>
              <td><input type='text' name='WIFINAME' value='$NETNAME' placeholder=''></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Wifi PSK:</td>
              <td><input type='text' name='WIFIPSK' value='$NETPW' placeholder=''></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Hidden SSID:</td>
              <td><select id='WHIDDEN' name='WHIDDEN'>
                <option value='0'$HID0>Disabled</option>
                <option value='1'$HID1>Enabled</option>
              </td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Use Assigned MAC:</td>
              <td><select id='WWIFIMAC' name='WWIFIMAC'>
                <option value='0'$WMC0>Disabled</option>
                <option value='1'$WMC1>Enabled</option>
              </td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>NTP Server:</td>
              <td><input type='text' name='NNTPSERVER' value='$NTPSERVER' placeholder=''></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Timezone:</td>
              <td><input type='text' name='NTIMEZONE' value='$TIMEZONE' placeholder=''></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'><h3>Webadmin settings</h3></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Enable web password:</td>
              <td><select id='NHTTPPROT' name='NHTTPPROT'>
                <option value='0'$NHP0>Disabled</option>
                <option value='1'$NHP1>Enabled</option>
              </select></td
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Username:</td>
              <td><input type='text' name='NHTTPUSER' value='$HTTPUSER' placeholder=''></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Password:</td>
              <td><input type='text' name='NHTTPPWD' value='$HTTPPWD' placeholder=''></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'><h3>Image Settings</h3></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Flip video verticaly:</td>
              <td><select id='NFLIP_VERTICAL' name='NFLIP_VERTICAL'>
                <option value='0'$NFV0>Disabled</option>
                <option value='1'$NFH1>Enabled</option>
              </select></td
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Flip video horizontaly:</td>
              <td><select id='NFLIP_HORIZONTAL' name='NFLIP_HORIZONTAL'>
                <option value='0'$NFH0>Disabled</option>
                <option value='1'$NFH1>Enabled</option>
              </select></td
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Enable timestamp:</td>
              <td><select id='NTIMESTAMP' name='NTIMESTAMP'>
                <option value='0'$NTS0>Disabled</option>
                <option value='1'$NTS1>Enabled</option>
              </select></td
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>24 hour time:</td>
              <td><select id='NTIME_24' name='NTIME_24'>
                <option value='0'$N240>Disabled</option>
                <option value='1'$N241>Enabled</option>
              </select></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Timestamp location:</td>
              <td><select id='NTIME_LOCATION' name='NTIME_LOCATION'>
                <option value='0'$NTIME0>Top Left</option>
                <option value='1'$NTIME1>Top Right</option>
                <option value='2'$NTIME2>Bottom Left</option>
                <option value='3'$NTIME3>Bottom Right</option>
              </select></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Enable autonight:</td>
              <td><select id='NAUTONIGHT' name='NAUTONIGHT'>
                <option value='0'$NAN0>Disabled</option>
                <option value='1'$NAN1>Enabled</option>
              </select></td
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Enable IR LED:</td>
              <td><select id='NIRLED' name='NIRLED'>
                <option value='0'$NAL0>Disabled</option>
                <option value='1'$NAL1>Enabled</option>
              </select></td
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'><h3>Enabled Streams</h3></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>RTSP Main Stream:</td>
              <td><select id='NENABLE_MAIN_RTSP' name='NENABLE_MAIN_RTSP'>
                <option value='0'$NRM0>Disabled</option>
                <option value='1'$NRM1>Enabled</option>
              </select></td
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>MJPEG Stream:</td>
              <td><select id='NENABLE_MJPEG' name='NENABLE_MJPEG'>
                <option value='0'$NM0>Disabled</option>
                <option value='1'$NM1>Enabled</option>
              </select></td
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>RTSP Sub Stream:</td>
              <td><select id='NENABLE_SUB_RTSP' name='NENABLE_SUB_RTSP'>
                <option value='0'$NRS0>Disabled</option>
                <option value='1'$NRS1>Enabled</option>
              </select></td>
            </tr>

            <tr>
              <td style='white-space:nowrap;align:left'>Stream authentication:</td>
              <td><select id='NENABLE_AUTH' name='NENABLE_AUTH'>
                <option value='0'$NAU0>Disabled</option>
                <option value='1'$NAU1>Enabled</option>
              </select></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Username:</td>
              <td><input type='text' name='NUSERNAME' value='$USERNAME' placeholder=''></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Password:</td>
              <td><input type='text' name='NPASSWORD' value='$PASSWORD' placeholder=''></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Enable Custom scripts:</td>
              <td><select id='NENABLE_SCRIPTS' name='NENABLE_SCRIPTS'>
                <option value='0'$NES0>Disabled</option>
                <option value='1'$NES1>Enabled</option>
              </select></td>
            </tr>
          </table>
          <p><button class='button bred' type='submit' name='SUBMIT' onclick="return confirm('Are you sure to save changes?')">Submit</button></p>
          <p><button class='button bred' type='button' name='REBOOT' onclick="reboot()">REBOOT</button></p>
          <p><button class='button bred' type='button' name='FACTORYRESET' onclick="factoryReset()">Factory Reset</button></p>
        </form>
      <p></p>
    </div>
    <script>
      function reboot() {
        if (confirm("Are you sure?") == true) {
          window.open('/cgi-bin/camreboot','_self');
        }  
      }
      function factoryReset() {
        if (confirm("Are you sure?") == true) {
          window.open('/cgi-bin/camreset','_self');
        }  
      }
    </script>
  </body>
</html>

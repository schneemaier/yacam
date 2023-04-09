Content-type: text/html

<!DOCTYPE html>
<html lang='en' class=''>
  <head>
    <title>YaCAM WIFI Setup</title>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width,initial-scale=1,user-scalable=no'/>
    <style>div,fieldset,input,select{padding:5px;font-size:1em;}fieldset{background:#f2f2f2;}p{margin:0.5em 0;}input{width:100%;box-sizing:border-box;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;background:#ffffff;color:#000000;}input[type=checkbox],input[type=radio]{width:1em;margin-right:6px;vertical-align:-1px;}select{width:100%;backgroud:#ffffff;color:#000000;}textarea{resize:none;width:98%;height:318px;padding:5px;overflow:auto;background:#ffffff;color:#000000;}body{text-align:center;font-family:verdana,sans-serif;background:#ffffff;}td{padding:0px;}button{border:0;border-radius:0.3rem;background:#1fa3ec;color:#ffffff;line-height:2.4rem;font-size:1.2rem;width:100%;-webkit-transition-duration:0.4s;transition-duration:0.4s;cursor:pointer;}button:hover{background:#0e70a4;}.bred{background:#d43535;}.bred:hover{background:#931f1f;}.bgrn{background:#47c266;}.bgrn:hover{background:#5aaf6f;}a{text-decoration:none;}.p{float:left;text1float:right;text-align:right;}</style>
  </head>
  <body>
    <div style='text-align:left;display:inline-block;color:#000000;min-width:340px;'>
      <h1>YaCAM WIFI Setup</h1>
      <h2>$VERSION</h2>
      <p></p>
      <div></div>
      <p></p>
        <form action='/cgi-bin/wifisave' method='POST'>
          <p>Set WIFI parameters<p>
          <div></div>
          <table style='width:100%'>
            <tr>
              <td style='white-space:nowrap;align:left'>Wifi PSK:</td>
              <td><input type='text' name='WIFINAME' value='$NETNAME' placeholder=''></td>
            </tr>
            <tr>
              <td style='white-space:nowrap;align:left'>Wifi PSK:</td>
              <td><input type='text' name='WIFIPSK' value='$NETPW' placeholder=''></td>
            </tr>
          </table>
          <p><button class='button bred' type='submit' name='SUBMIT'>Submit</button>
        </form>
      <p></p>
    </div>
  </body>
</html>

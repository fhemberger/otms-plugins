UI: Report
==========

Version: 1.01 (2008-12-30)
Author:  Frederic Hemberger, mail[at]frederic-hemberger[dot]de

UI: Report is an user interface enhancement for OTMS, which allows problem
reporting by editors in SmartEdit view. Additionally, the report is
complemented by essential information (user information, project, page id,
langauge variant, template name, etc.) for easier bug tracking by developers or
helpdesk personnel.

This is third party software. The author is not affiliated in any manner with
RedDot Solutions AG or Open Text Corporation.

If you make modifications/improvements to this software, please drop me a mail,
so I can include it in future releases. Of cause, it would be also interesting
to hear, who uses this software. Feedback is always appreciated!



Example Report
==============

   Date: 02.07.2008 09:45

   Report
   ======
   Text editor does not allow bullet lists.

   User Information
   ================
   User name:  FHemberger (Frederic Hemberger)
   User level: 1
   User agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)

   Page Information
   ================
   Project:   Up And Away (Navigation Manager)
   Page:      Contact (ID: 7191)
   Status:    Released
   Language:  English (ENG)
   Template:  Content Modules/Text with image



INSTALLATION
============

1. Copy the /UIReport folder to the /ASP/PlugIns folder of your RedDot CMS installation.

2. Include the following code in your template to enable reporting:

   <!IoRangeRedDotEditOnly>
   <a href="#" onclick="window.open('PlugIns/UIReport/UIReport.asp', 'UIReport', 'width=650,height=550');void(0);">
      <img src="UIReport/reddotreport.gif" alt="Report a problem" border="0" />
   </a><!/IoRangeRedDotEditOnly>



CONFIGURATION
=============

Open /UIReport/UIReport.asp for email configuration:

' -- Configuration ------------------------------------------------------------
' Recipient
EMAIL_TO = "reddot-admin@yourcompany.com"

' From address, will be replaced by user's email (if available)
EMAIL_FROM_FALLBACK = "noreply@yourcompany.com"
' -----------------------------------------------------------------------------



VERSION HISTORY
===============

1.01 - Minor fixes: Changed RegEx for filtering HTML tags (Thanks to Stefan Buchali)

1.0  - Initial Release



LICENSE (The MIT-License)
=======

Copyright (c) 2008 Frederic Hemberger

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

# OTRS-Responsible-Per-Customer-User  
- Build for OTRS CE v6.0  
- Auto set ticket responsible user based on customer user profile  
  
Case Reference: https://forums.otterhub.org/viewtopic.php?f=53&t=41851  

1. Create a new dynamic field  
         Name : PIC  
         Label : Person In Charge  
         Field Type: Text / Dropdown (Recommended)  
         Object Type: Customer User  
         
         *if using dropdown, fill in agent username.  
      
      
 2. Enable dynamic field 'PIC' at customer user mapping ($OTRS_HOME/Kernel/Config.pm)  
   
        [ 'DynamicField_PIC', undef, 'PIC', 0, 0, 'dynamic_field', undef, 0, undef, undef ],  
        
 3. This field (PIC) should be visible at customer user profile.  
   
 [![1.png](https://i.postimg.cc/xTWBzxp5/1.png)](https://postimg.cc/jL48VXbn)  
   
 4. Update PIC field with OTRS agent username (agent who will be auto seletected as resposible of the ticket).  
   
 5. Navigate to Admin > System Configuration > Ticket::EventModulePost###4150-ResponsibleFromCustomerUser and enable the config.  
 
 6. Upon ticket is created or customer user is updated, this module will update the ticket responsible based on customer user profile (PIC field value).  

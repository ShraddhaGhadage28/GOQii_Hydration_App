# Project Name
GOQii Water Hydration App

# App Features
1. User can fill water intake for daily basis
2. User can update and delete water intake
3. Three screens are align in this App

   ## screen description
   1.Water Level Screen : User can add and reset water intake.
                   There are two options. User can select water intake from glass or bottel, based on user input water intake quantity would be render on user interface.
                   Once user select save CTA water intake data save in to the core data
                   Tapped on reset water intake data would be reset onnn previous state(The data which had been stored in core data)
                   Local notification is implemennted to give indication user about his water intake
                   User would be get pop up once user achieve his water intake goal
   2.Setting Screen : Here user has provision to set his water itake goal
                      Tapped on Goal row, alert pop up would be render and there user can enter his water intake goal
                    
   3.History Screen : User cann see his water inntake history 
                      Right swipe delete option is there, with delete option user can delate specific water intake record
                      Tapped on row update pop up would be render, help of this pop up user can update his water intake history

# Technical Implementation
1. MVVM Architecture Use
2. Core data implemenntationn to save water intake entry
3. Local Notification, update user about his goal
4. Render pop up based on user action. i.e supposed user achive water intake goal

# truckly
This application was created to solve a common problem: the lack of a dedicated app for food trucks that helps both customers and owners stay updated.

Many times, customers go to a food truck location only to find out that it has moved without any notice. This creates frustration and inconvenience.

That’s why I developed Truckly — an application that brings both food truck owners and customers together in one place.
Truckly helps owners manage their truck information, location, and availability, while allowing customers to easily discover food trucks, check their status, and stay informed

# sign-up
The Sign Up screen allows new users to create an account.
During registration:
The user enters their email and password
The user selects their role (Owner or Customer)
The account is created using Supabase Authentication
The user role is stored in the database (profiles table)
After successful registration, the user can log in and access the app according to their selected role.
<img width="465" height="827" alt="Screenshot 2026-02-22 194458" src="https://github.com/user-attachments/assets/02d95e2c-77bf-4c53-a3c4-49bc10e5333e" />
<img width="1907" height="1007" alt="Screenshot 2026-02-22 195547" src="https://github.com/user-attachments/assets/143a078a-4c9b-4443-b45c-a1dc44c7ee79" />

# log-in 
The Login screen allows existing users to securely access their accounts using email and password.
After logging in:

The system verifies the user using Supabase Authentication
The app automatically checks the user role (Owner or Customer)
The user is redirected to the appropriate screen:
Customer → Home Screen
Owner → Owner Dashboard
This ensures a smooth and personalized experience for each user type.
<img width="464" height="828" alt="Screenshot 2026-02-22 194410" src="https://github.com/user-attachments/assets/9ae56b5f-6f43-4543-a70d-5d4abd094a5e" />

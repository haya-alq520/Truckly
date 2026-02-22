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

# Customers
The customer side of the application, designed for users who want to explore and interact with food trucks.
# Home Screen "Discover"
Displays all food trucks stored in the database.
Users can view truck information, check availability status, and navigate to the details page.
Data is fetched from Supabase and handled with proper loading and error states.

<img width="454" height="817" alt="Screenshot 2026-02-22 194817" src="https://github.com/user-attachments/assets/0224af10-94b0-4783-8ac1-e9b731c030a5" />

<img width="1913" height="1016" alt="Screenshot 2026-02-22 195618" src="https://github.com/user-attachments/assets/3ea5dd1b-b249-46d1-aae1-a9987c654f22" />

# Truck Details
After selecting a food truck, users can view its image, name, category, and location.  
They can open the location in Google Maps, add a review, and see previous customer reviews.

<img width="473" height="829" alt="Screenshot 2026-02-22 194949" src="https://github.com/user-attachments/assets/0c765884-f227-4e81-8112-041090170cfb" />

# Add Review
Allows customers to rate a food truck, write a comment, and optionally add photos.  
The review is stored in the database and displayed in the Truck Details screen.

<img width="463" height="828" alt="Screenshot 2026-02-22 201522" src="https://github.com/user-attachments/assets/907f7e40-fe5b-47e6-ab06-cfd30388a515" />


<img width="1914" height="1007" alt="Screenshot 2026-02-22 195638" src="https://github.com/user-attachments/assets/3068965d-8d0a-44ce-accb-10d042898b0e" />

# Profile Screen
The Profile screen provides users with access to their account information and secure sign-out functionality.  
It ensures proper session management and a smooth logout experience using Supabase Authentication.

<img width="466" height="823" alt="Screenshot 2026-02-22 194611" src="https://github.com/user-attachments/assets/8e353473-5d65-4828-b94c-926c12d8edee" />

# Owner Section
The Owner section provides a dedicated management interface for food truck owners.  
It includes a dashboard displaying average ratings and recent reviews, along with editing tools to update truck details, location, availability status, and images.  
This ensures real-time updates for customers and improves overall communication between owners and users.








import pandas as pd
import mysql.connector
from mysql.connector import Error
import secrets
import string
import os
import bcrypt

file_path = "users_passwords.txt"
if os.path.exists(file_path):
    os.remove(file_path)
    print(f"Le fichier {file_path} a été supprimé.")
else:
    print(f"Le fichier {file_path} n'existe pas.")

def generate_password(length=12):
    alphabet = string.ascii_letters + string.digits + string.punctuation
    password = ''.join(secrets.choice(alphabet) for _ in range(length))
    return password

def hash_password_domjudge(password):
    salt = bcrypt.gensalt(rounds=12, prefix=b'2a')
    hashed = bcrypt.hashpw(password.encode(), salt)
    return hashed.decode('utf-8')

def create_teams_from_excel(filename, host, port, user, password, database):
    try:
        connection = mysql.connector.connect(
            host=host,
            user=user,
            password=password,
            database=database,
            port=port 
        )

        if not connection.is_connected():
            print("Échec de la connexion MySQL.")
            return

        cursor = connection.cursor()
        df = pd.read_excel(filename)

        with open("users_passwords.txt", "w") as f:
            for i, row in df.iterrows():
                try:
                    print(f"Traitement ligne {i}")
                    name = str(row['Teams']).strip()
                    if not name:
                        print(f"Ligne {i + 2} - Nom d'équipe manquant")
                        continue
                    
                    raw_password = generate_password()
                    hashed_password = hash_password_domjudge(raw_password)

                    
                    cursor.execute(
                        "INSERT INTO team (name, enabled, penalty, categoryid) VALUES (%s, 1, 0, 3)",
                        (name,)
                    )
                    teamid = cursor.lastrowid
                    
                    cursor.execute(
                        """INSERT INTO user (username, name, password, teamid, enabled)
                        VALUES (%s, %s, %s, %s, 1)""",
                        (name, name, hashed_password, teamid)
                    )
                    userid = cursor.lastrowid
                    
                    cursor.execute(
                        "INSERT INTO userrole (userid, roleid) VALUES (%s, 3)",
                        (userid,)
                    )

                    f.write(f"{name}: {raw_password}\n")

                except Exception as e:
                    print(f"Erreur ligne {i}: {str(e)}")
                    continue

        connection.commit()
        print("Création terminée. Tous les utilisateurs ont le rôle 'team' (roleid=3).")

    except Error as e:
        print(f"Erreur MySQL: {e}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

create_teams_from_excel("teams.xlsx", "localhost", "13306", "root", "rootpw", "domjudge")
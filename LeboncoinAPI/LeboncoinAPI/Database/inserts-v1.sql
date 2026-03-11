/*======================================================================================*/
/* MIGRATION EF CORE - SCRIPT D'INSERTION COMPLET (POSTGRESQL)                          */
/* Adapté au nouveau schéma (suppression photo/cartebancaire, ajout lienphoto)          */
/*======================================================================================*/

/*======================================================================================*/
/* BLOC 1 : TABLES PARENTES (Sans clés étrangères)                                      */
/*======================================================================================*/

/* 1. Table : compensation */
INSERT INTO public.compensation (idcompensation, nomcompensation) VALUES
(1, 'Remboursement total de la réservation'),
(2, 'Remboursement partiel de la réservation'),
(3, 'Remboursement des frais annexes'),
(4, 'Indemnisation pour dépenses supplémentaires'),
(5, 'Remboursement des objets endommagés ou volés'),
(6, 'Remboursement pour équipements ou services manquants'),
(7, 'Fourniture d’un logement alternatif équivalent ou supérieur'),
(8, 'Bons, crédits ou services gratuits'),
(9, 'Compensation pour stress ou gêne'),
(10, 'Compensation pour inconfort'),
(11, 'Compensation pour perte de temps'),
(12, 'Compensation pour annulation de dernière minute par le propriétaire'),
(13, 'Autre compensation commerciale');

/* 2. Table : categorie */
INSERT INTO public.categorie (idcategorie, nomcategorie) VALUES
(1, 'Hébergement'),
(2, 'Commodité'),
(3, 'Service'),
(4, 'Équipement');

/* 3. Table : region */
INSERT INTO public.region (idregion, nomregion) VALUES
(1, 'Auvergne-Rhône-Alpes'),
(2, 'Bourgogne-Franche-Comté'),
(3, 'Bretagne'),
(4, 'Centre-Val de Loire'),
(5, 'Corse'),
(6, 'Grand Est'),
(7, 'Hauts-de-France'),
(8, 'Île-de-France'),
(9, 'Normandie'),
(10, 'Nouvelle-Aquitaine'),
(11, 'Occitanie'),
(12, 'Pays de la Loire'),
(13, 'Provence-Alpes-Côte d''Azur');

/* 4. Table : heure */
INSERT INTO public.heure (idheure, heure) VALUES
(1, '08:00:00'), (2, '09:00:00'), (3, '10:00:00'), (4, '11:00:00'),
(5, '12:00:00'), (6, '13:00:00'), (7, '14:00:00'), (8, '15:00:00'),
(9, '16:00:00'), (10, '17:00:00'), (11, '18:00:00'), (12, '19:00:00'),
(13, '20:00:00');

/* 5. Table : date */
INSERT INTO public.date (iddate, date) VALUES
(1, '2025-11-01'), (2, '2025-11-02'), (3, '2025-11-03'), (4, '2025-11-04'),
(5, '2025-11-05'), (6, '2025-11-06'), (7, '2025-11-07'), (8, '2025-11-08'),
(9, '2025-11-09'), (10, '2025-11-10'), (11, '2025-11-11'), (12, '2025-11-12'),
(13, '2025-11-13'), (14, '2025-11-14'), (15, '2025-11-15'), (16, '2025-11-16'),
(17, '2025-11-17'), (18, '2025-11-18'), (19, '2025-11-19'), (20, '2025-11-20'),
(21, '2025-11-21'), (22, '2025-11-22'), (23, '2025-11-23'), (24, '2025-11-24'),
(25, '2025-11-25'), (26, '2025-11-26'), (27, '2025-11-27'), (28, '2025-11-28'),
(29, '2025-11-29'), (30, '2025-11-30');

/* 6. Table : typevoyageur */
INSERT INTO public.typevoyageur (idtypevoyageur, nomtypevoyageur) VALUES
(1, 'Adulte'),
(2, 'Enfant'),
(3, 'Bébé'),
(4, 'Animal de compagnie');


/*======================================================================================*/
/* BLOC 2 : NIVEAU 2 (Dépendent du Bloc 1)                                              */
/*======================================================================================*/

/* 1. Table : departement */
INSERT INTO public.departement (iddepartement, idregion, numerodepartement, nomdepartement) VALUES
(1, 1, '01', 'Ain'), (2, 7, '02', 'Aisne'), (3, 1, '03', 'Allier'), (4, 13, '04', 'Alpes-de-Haute-Provence'),
(5, 13, '05', 'Hautes-Alpes'), (6, 13, '06', 'Alpes-Maritimes'), (7, 1, '07', 'Ardèche'), (8, 6, '08', 'Ardennes'),
(9, 11, '09', 'Ariège'), (10, 6, '10', 'Aube'), (11, 11, '11', 'Aude'), (12, 11, '12', 'Aveyron'),
(13, 13, '13', 'Bouches-du-Rhône'), (14, 9, '14', 'Calvados'), (15, 1, '15', 'Cantal'), (16, 10, '16', 'Charente'),
(17, 10, '17', 'Charente-Maritime'), (18, 4, '18', 'Cher'), (19, 10, '19', 'Corrèze'), (20, 5, '2A', 'Corse-du-Sud'),
(21, 5, '2B', 'Haute-Corse'), (22, 2, '21', 'Côte-d''Or'), (23, 3, '22', 'Côtes-d''Armor'), (24, 10, '23', 'Creuse'),
(25, 10, '24', 'Dordogne'), (26, 2, '25', 'Doubs'), (27, 1, '26', 'Drôme'), (28, 9, '27', 'Eure'),
(29, 4, '28', 'Eure-et-Loir'), (30, 3, '29', 'Finistère'), (31, 11, '30', 'Gard'), (32, 11, '31', 'Haute-Garonne'),
(33, 11, '32', 'Gers'), (34, 10, '33', 'Gironde'), (35, 11, '34', 'Hérault'), (36, 3, '35', 'Ille-et-Vilaine'),
(37, 4, '36', 'Indre'), (38, 4, '37', 'Indre-et-Loire'), (39, 1, '38', 'Isère'), (40, 2, '39', 'Jura'),
(41, 10, '40', 'Landes'), (42, 4, '41', 'Loir-et-Cher'), (43, 1, '42', 'Loire'), (44, 1, '43', 'Haute-Loire'),
(45, 12, '44', 'Loire-Atlantique'), (46, 4, '45', 'Loiret'), (47, 11, '46', 'Lot'), (48, 10, '47', 'Lot-et-Garonne'),
(49, 11, '48', 'Lozère'), (50, 12, '49', 'Maine-et-Loire'), (51, 9, '50', 'Manche'), (52, 6, '51', 'Marne'),
(53, 6, '52', 'Haute-Marne'), (54, 12, '53', 'Mayenne'), (55, 6, '54', 'Meurthe-et-Moselle'), (56, 6, '55', 'Meuse'),
(57, 3, '56', 'Morbihan'), (58, 6, '57', 'Moselle'), (59, 2, '58', 'Nièvre'), (60, 7, '59', 'Nord'),
(61, 7, '60', 'Oise'), (62, 9, '61', 'Orne'), (63, 7, '62', 'Pas-de-Calais'), (64, 1, '63', 'Puy-de-Dôme'),
(65, 10, '64', 'Pyrénées-Atlantiques'), (66, 11, '65', 'Hautes-Pyrénées'), (67, 11, '66', 'Pyrénées-Orientales'),
(68, 6, '67', 'Bas-Rhin'), (69, 6, '68', 'Haut-Rhin'), (70, 1, '69', 'Rhône'), (71, 2, '70', 'Haute-Saône'),
(72, 2, '71', 'Saône-et-Loire'), (73, 12, '72', 'Sarthe'), (74, 1, '73', 'Savoie'), (75, 1, '74', 'Haute-Savoie'),
(76, 8, '75', 'Paris'), (77, 9, '76', 'Seine-Maritime'), (78, 8, '77', 'Seine-et-Marne'), (79, 8, '78', 'Yvelines'),
(80, 10, '79', 'Deux-Sèvres'), (81, 7, '80', 'Somme'), (82, 11, '81', 'Tarn'), (83, 11, '82', 'Tarn-et-Garonne'),
(84, 13, '83', 'Var'), (85, 13, '84', 'Vaucluse'), (86, 12, '85', 'Vendée'), (87, 10, '86', 'Vienne'),
(88, 10, '87', 'Haute-Vienne'), (89, 6, '88', 'Vosges'), (90, 2, '89', 'Yonne'), (91, 2, '90', 'Territoire de Belfort'),
(92, 8, '91', 'Essonne'), (93, 8, '92', 'Hauts-de-Seine'), (94, 8, '93', 'Seine-Saint-Denis'), (95, 8, '94', 'Val-de-Marne'),
(96, 8, '95', 'Val-d''Oise');

/* 2. Table : typehebergement */
INSERT INTO public.typehebergement (idtypehebergement, idcategorie, nomtypehebergement) VALUES
(1, 1, 'Appartement'),
(2, 1, 'Maison'),
(3, 1, 'Chambre'),
(4, 1, 'Atypique');

/* 3. Table : commodite */
INSERT INTO public.commodite (idcommodite, idcategorie, nomcommodite) VALUES
(1, 2, 'Wi-Fi'), (2, 2, 'Télévision'), (3, 2, 'Climatisation'), (4, 2, 'Chauffage'),
(5, 2, 'Cuisine équipée'), (6, 2, 'Lave-linge'), (7, 2, 'Sèche-linge'), (8, 2, 'Parking gratuit'),
(9, 2, 'Piscine'), (10, 2, 'Jacuzzi'), (11, 2, 'Salle de sport'), (12, 2, 'Ascenseur'),
(13, 2, 'Accès handicapé'), (14, 2, 'Animaux acceptés'), (15, 2, 'Fumeur autorisé'), (16, 2, 'Espace de travail'),
(17, 2, 'Cheminée'), (18, 2, 'Détecteur de fumée'), (19, 2, 'Trousse de premiers secours'), (20, 2, 'Extincteur'),
(21, 2, 'Kit de nettoyage');


/*======================================================================================*/
/* BLOC 3 : TABLES GEOGRAPHIQUES (Dépendent du Bloc 2)                                  */
/*======================================================================================*/

/* 1. Table : ville */
INSERT INTO public.ville (idville, iddepartement, codepostal, nomville, taxedesejour) VALUES
(1, 76, '75000', 'Paris', 2.50),
(2, 13, '13000', 'Marseille', 1.80),
(3, 70, '69000', 'Lyon', 2.00),
(4, 32, '31000', 'Toulouse', 1.50),
(5, 6, '06000', 'Nice', 2.20),
(6, 45, '44000', 'Nantes', 1.20),
(7, 35, '34000', 'Montpellier', 1.60),
(8, 68, '67000', 'Strasbourg', 1.70),
(9, 34, '33000', 'Bordeaux', 2.10),
(10, 60, '59000', 'Lille', 1.40),
(11, 36, '35000', 'Rennes', 1.10),
(12, 52, '51100', 'Reims', 1.30),
(13, 43, '42000', 'Saint-Étienne', 0.90),
(14, 84, '83000', 'Toulon', 1.50),
(15, 77, '76600', 'Le Havre', 1.00),
(16, 39, '38000', 'Grenoble', 1.40),
(17, 22, '21000', 'Dijon', 1.20),
(18, 50, '49000', 'Angers', 1.00),
(19, 31, '30000', 'Nîmes', 1.10),
(20, 75, '74000', 'Annecy', 1.80);

/* 2. Table : adresse */
INSERT INTO public.adresse (idadresse, idville, numerorue, nomrue) VALUES
(1, 1, 15, 'Rue de Rivoli'),
(2, 2, 8, 'Avenue du Prado'),
(3, 3, 42, 'Rue de la République'),
(4, 4, 12, 'Place du Capitole'),
(5, 5, 5, 'Promenade des Anglais'),
(6, 6, 23, 'Cours des 50 Otages'),
(7, 7, 18, 'Rue Foch'),
(8, 8, 7, 'Place Kléber'),
(9, 9, 30, 'Rue Sainte-Catherine'),
(10, 10, 11, 'Boulevard de la Liberté'),
(11, 1, 88, 'Avenue des Champs-Élysées'),
(12, 3, 55, 'Rue Garibaldi'),
(13, 20, 12, 'Rue Royale'),
(14, 9, 4, 'Place de la Bourse'),
(15, 1, 2, 'Rue de la Paix');


/*======================================================================================*/
/* BLOC 4 : UTILISATEURS ET PROFILS (Dépendent des Blocs 1 et 3)                        */
/*======================================================================================*/

/* 1. Table : utilisateur */
/* RETRAIT DE LA COLONNE 'idcartebancaire' */
INSERT INTO public.utilisateur (
    idutilisateur, idadresse, iddate, pseudonyme, email, email_verified_at, 
    password, telephoneutilisateur, phone_verified, identity_verified, solde, 
    remember_token, two_factor_secret, two_factor_recovery_codes, two_factor_confirmed_at, profile_photo_path
) VALUES
(1, 1, 1, 'JeanD', 'jean.dupont@email.com', '2025-11-01 10:00:00', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0601020304', true, true, 150.00, null, null, null, null, null),
(2, 2, 2, 'MarieM', 'marie.martin@email.com', '2025-11-02 11:30:00', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0611223344', true, true, 300.50, null, null, null, null, null),
(3, 3, 3, 'LucieB', 'lucie.bernard@email.com', '2025-11-03 09:15:00', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0622334455', true, false, 0.00, null, null, null, null, null),
(4, 4, 4, 'PaulR', 'paul.richard@email.com', '2025-11-04 14:20:00', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0633445566', false, false, 50.00, null, null, null, null, null),
(5, 5, 5, 'SophieL', 'sophie.lefevre@email.com', '2025-11-05 16:45:00', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0644556677', true, true, 500.00, null, null, null, null, null),
(6, 6, 6, 'AgenceSud', 'contact@agencesud.com', '2025-11-06 08:00:00', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0491001122', true, true, 1200.00, null, null, null, null, null),
(7, 7, 7, 'LocaZen', 'contact@locazen.fr', '2025-11-07 09:30:00', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0467002233', true, true, 850.00, null, null, null, null, null);

/* 2. Table : particulier */
INSERT INTO public.particulier (idutilisateur, nomutilisateur, prenomutilisateur, civilite, iddate) VALUES
(1, 'Dupont', 'Jean', 'Monsieur', 10),
(2, 'Martin', 'Marie', 'Madame', 15),
(3, 'Bernard', 'Lucie', 'Madame', 20),
(4, 'Richard', 'Paul', 'Monsieur', 25),
(5, 'Lefevre', 'Sophie', 'Madame', 30);

/* 3. Table : professionnel */
INSERT INTO public.professionnel (idutilisateur, numsiret, nomsociete, secteuractivite) VALUES
(6, 12345678901234, 'Agence Sud Location', 'Immobilier de loisirs'),
(7, 98765432109876, 'LocaZen SAS', 'Gestion locative courte durée');


/*======================================================================================*/
/* BLOC 5 : ANNONCES (Dépendent des Blocs 1, 2, 3 et 4)                                 */
/*======================================================================================*/

/* 1. Table : annonce */
/* AJOUT DE LA COLONNE 'lienphoto' (max 50 caractères selon le modèle ! J'ai raccourci les liens) */
INSERT INTO public.annonce (
    idannonce, idadresse, iddate, idheuredepart, idtypehebergement, idheurearrivee, idutilisateur, 
    titreannonce, descriptionannonce, nombreetoilesleboncoin, lienphoto, montantacompte, pourcentageacompte, 
    prixnuitee, capacite, nbchambres, minimumnuitee, possibiliteanimaux, nombrebebesmax, 
    possibilitefumeur, estverifie, smsverifie
) VALUES
(1, 8, 5, 4, 1, 8, 1, 'Superbe appartement vue Tour Eiffel', 'Magnifique T3 refait à neuf, idéalement situé en plein cœur de Paris. Vous profiterez d''une vue imprenable sur la Tour Eiffel depuis le balcon filant. Cuisine suréquipée, literie haut de gamme.', 5, 'img/annonces/1.jpg', null, 30, 180.00, 4, 2, 2, false, 1, false, true, true),
(2, 9, 6, 5, 2, 9, 2, 'Maison de charme avec piscine', 'Grande maison familiale à quelques minutes des plages de Marseille. Piscine chauffée, grand jardin arboré avec barbecue. Parfait pour des vacances en famille ou entre amis.', 4, 'img/annonces/2.jpg', 200.00, null, 250.00, 8, 4, 3, true, 2, false, true, false),
(3, 10, 7, 3, 3, 7, 3, 'Chambre cosy centre historique', 'Chambre privée dans un appartement typique lyonnais (Canut). Accès partagé à la cuisine et la salle de bain. Quartier très vivant avec de nombreux bouchons.', 4, 'img/annonces/3.jpg', null, null, 65.00, 2, 1, 1, false, 0, true, false, false),
(4, 11, 8, 4, 4, 8, 4, 'Péniche romantique sur le Canal du Midi', 'Passez une nuit insolite à bord de cette péniche amarrée au cœur de Toulouse. Ambiance chaleureuse avec boiseries, terrasse sur le pont pour le petit-déjeuner.', 5, 'img/annonces/4.jpg', 50.00, null, 120.00, 2, 1, 2, true, 0, false, true, true),
(5, 12, 9, 5, 1, 9, 6, 'Studio moderne bord de mer', 'Studio très lumineux sur la Promenade des Anglais. Accès direct à la plage. Idéal pour un couple. Climatisation et Wi-Fi haut débit inclus.', 3, 'img/annonces/5.jpg', null, 50, 90.00, 2, 0, 1, false, 0, false, true, true),
(6, 13, 10, 6, 2, 10, 7, 'Grande villa Nantaise', 'Belle maison de ville proche des Machines de l''Île. Grand espace de vie, décoration contemporaine. Stationnement privé gratuit.', null, 'img/annonces/6.jpg', null, 25, 140.00, 6, 3, 2, false, 1, false, true, true);


/*======================================================================================*/
/* BLOC 6 : LIAISONS ANNONCES (relier et photo ont été supprimées)                      */
/*======================================================================================*/

/* 1. Table : proposer */
INSERT INTO public.proposer (idcommodite, idannonce) VALUES
(1, 1), (2, 1), (5, 1), (12, 1), 
(1, 2), (2, 2), (5, 2), (8, 2), (9, 2), (14, 2), 
(1, 3), (4, 3), 
(1, 4), (17, 4), (18, 4), 
(1, 5), (3, 5), (5, 5), 
(1, 6), (2, 6), (5, 6), (6, 6), (8, 6);

/* 2. Table : favoriser */
INSERT INTO public.favoriser (idutilisateur, idannonce) VALUES
(1, 2), (1, 5), 
(2, 1), 
(3, 4), (3, 6), 
(4, 2), 
(5, 1), (5, 3);


/*======================================================================================*/
/* BLOC 7 : INTERACTIONS (Réservations, Avis, Messages, Incidents)                      */
/*======================================================================================*/

/* 1. Table : reservation */
INSERT INTO public.reservation (
    idreservation, idannonce, iddatedebutreservation, iddatefinreservation, 
    idutilisateur, nomclient, prenomclient, telephoneclient
) VALUES
(1, 1, 10, 15, 2, 'Martin', 'Marie', '0611223344'), 
(2, 2, 20, 27, 4, 'Richard', 'Paul', '0633445566'), 
(3, 4, 12, 14, 5, 'Lefevre', 'Sophie', '0644556677'), 
(4, 5, 5, 12, 1, 'Dupont', 'Jean', '0601020304');

/* 2. Table : avis */
INSERT INTO public.avis (idavis, idannonce, iddate, idutilisateur, texteavis, nombreetoiles) VALUES
(1, 1, 16, 2, 'Séjour incroyable, l''appartement est sublime et la vue sur la Tour Eiffel est magique !', 5.0),
(2, 4, 15, 5, 'Très romantique mais un peu bruyant le matin avec les péniches voisines.', 4.0),
(3, 5, 13, 1, 'Studio propre et fonctionnel. Propriétaire très réactif.', 4.5);

/* 3. Table : message */
INSERT INTO public.message (idmessage, idutilisateurreceveur, iddate, idutilisateurexpediteur, contenumessage) VALUES
(1, 1, 8, 2, 'Bonjour, est-il possible d''arriver un peu plus tôt que prévu ?'),
(2, 2, 8, 1, 'Bonjour Marie, oui bien sûr, je peux vous accueillir à partir de 14h sans problème.'),
(3, 6, 4, 1, 'Bonjour, le studio dispose-t-il bien du Wi-Fi ?');

/* 4. Table : incident */
INSERT INTO public.incident (
    idincident, idutilisateur, idreservation, iddate, motifincident, descriptionincident, 
    etape, estclasse, estrembourse, estremisaucontentieux, explicationproprietaire
) VALUES
(1, 2, 1, 16, 'Problème de plomberie', 'Fuite d''eau importante dans la salle de bain dès le 2ème jour.', 2, false, false, false, 'Le plombier est intervenu mais le dégât était déjà fait. J''attends le retour de l''assurance.'),
(2, 4, 2, 25, 'Propreté', 'La piscine n''était pas nettoyée à notre arrivée (feuilles et algues).', 3, true, true, false, 'Le pisciniste a eu un problème de camion, j''ai accordé un remboursement partiel.'),
(3, 5, 3, 15, 'Nuisance sonore', 'Fête étudiante dans la péniche voisine jusqu''à 4h du matin.', 1, false, false, false, null);

/* 5. Table : demander */
INSERT INTO public.demander (idincident, idcompensation) VALUES
(1, 4), 
(2, 2), 
(3, 9);


/*======================================================================================*/
/* REINITIALISATION DE TOUTES LES SEQUENCES (PostgreSQL IDENTITY)                       */
/*======================================================================================*/
/* Utilisation de pg_get_serial_sequence car "GENERATED BY DEFAULT AS IDENTITY" génère  */
/* des noms de séquences dynamiques. C'est la méthode la plus sûre et robuste.          */

SELECT setval(pg_get_serial_sequence('public.compensation', 'idcompensation'), (SELECT MAX(idcompensation) FROM public.compensation));
SELECT setval(pg_get_serial_sequence('public.categorie', 'idcategorie'), (SELECT MAX(idcategorie) FROM public.categorie));
SELECT setval(pg_get_serial_sequence('public.region', 'idregion'), (SELECT MAX(idregion) FROM public.region));
SELECT setval(pg_get_serial_sequence('public.heure', 'idheure'), (SELECT MAX(idheure) FROM public.heure));
SELECT setval(pg_get_serial_sequence('public.date', 'iddate'), (SELECT MAX(iddate) FROM public.date));
SELECT setval(pg_get_serial_sequence('public.typevoyageur', 'idtypevoyageur'), (SELECT MAX(idtypevoyageur) FROM public.typevoyageur));

SELECT setval(pg_get_serial_sequence('public.departement', 'iddepartement'), (SELECT MAX(iddepartement) FROM public.departement));
SELECT setval(pg_get_serial_sequence('public.typehebergement', 'idtypehebergement'), (SELECT MAX(idtypehebergement) FROM public.typehebergement));
SELECT setval(pg_get_serial_sequence('public.commodite', 'idcommodite'), (SELECT MAX(idcommodite) FROM public.commodite));

SELECT setval(pg_get_serial_sequence('public.ville', 'idville'), (SELECT MAX(idville) FROM public.ville));
SELECT setval(pg_get_serial_sequence('public.adresse', 'idadresse'), (SELECT MAX(idadresse) FROM public.adresse));

SELECT setval(pg_get_serial_sequence('public.utilisateur', 'idutilisateur'), (SELECT MAX(idutilisateur) FROM public.utilisateur));

SELECT setval(pg_get_serial_sequence('public.annonce', 'idannonce'), (SELECT MAX(idannonce) FROM public.annonce));

SELECT setval(pg_get_serial_sequence('public.reservation', 'idreservation'), (SELECT MAX(idreservation) FROM public.reservation));
SELECT setval(pg_get_serial_sequence('public.avis', 'idavis'), (SELECT MAX(idavis) FROM public.avis));
SELECT setval(pg_get_serial_sequence('public.message', 'idmessage'), (SELECT MAX(idmessage) FROM public.message));
SELECT setval(pg_get_serial_sequence('public.incident', 'idincident'), (SELECT MAX(idincident) FROM public.incident));

/* Fin du script d'insertion global */
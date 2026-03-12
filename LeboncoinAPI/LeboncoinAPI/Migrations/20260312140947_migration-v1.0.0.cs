using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace LeboncoinAPI.Migrations
{
    /// <inheritdoc />
    public partial class migrationv100 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "categorie",
                columns: table => new
                {
                    idcategorie = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomcategorie = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_categorie", x => x.idcategorie);
                });

            migrationBuilder.CreateTable(
                name: "compensation",
                columns: table => new
                {
                    idcompensation = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomcompensation = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_compensation", x => x.idcompensation);
                });

            migrationBuilder.CreateTable(
                name: "date",
                columns: table => new
                {
                    iddate = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    date = table.Column<DateOnly>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_date", x => x.iddate);
                });

            migrationBuilder.CreateTable(
                name: "heure",
                columns: table => new
                {
                    idheure = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    heure = table.Column<TimeOnly>(type: "time without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_heure", x => x.idheure);
                });

            migrationBuilder.CreateTable(
                name: "permission",
                columns: table => new
                {
                    idpermission = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nompermission = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_permission", x => x.idpermission);
                });

            migrationBuilder.CreateTable(
                name: "region",
                columns: table => new
                {
                    idregion = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomregion = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_region", x => x.idregion);
                });

            migrationBuilder.CreateTable(
                name: "role",
                columns: table => new
                {
                    idrole = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomrole = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_role", x => x.idrole);
                });

            migrationBuilder.CreateTable(
                name: "typevoyageur",
                columns: table => new
                {
                    idtypevoyageur = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomtypevoyageur = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_typevoyageur", x => x.idtypevoyageur);
                });

            migrationBuilder.CreateTable(
                name: "commodite",
                columns: table => new
                {
                    idcommodite = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idcategorie = table.Column<int>(type: "integer", nullable: false),
                    nomcommodite = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_commodite", x => x.idcommodite);
                    table.ForeignKey(
                        name: "FK_commodite_categorie_idcategorie",
                        column: x => x.idcategorie,
                        principalTable: "categorie",
                        principalColumn: "idcategorie",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "typehebergement",
                columns: table => new
                {
                    idtypehebergement = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idcategorie = table.Column<int>(type: "integer", nullable: false),
                    nomtypehebergement = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_typehebergement", x => x.idtypehebergement);
                    table.ForeignKey(
                        name: "FK_typehebergement_categorie_idcategorie",
                        column: x => x.idcategorie,
                        principalTable: "categorie",
                        principalColumn: "idcategorie",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "departement",
                columns: table => new
                {
                    iddepartement = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idregion = table.Column<int>(type: "integer", nullable: false),
                    numerodepartement = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: true),
                    nomdepartement = table.Column<string>(type: "character varying(25)", maxLength: 25, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_departement", x => x.iddepartement);
                    table.ForeignKey(
                        name: "FK_departement_region_idregion",
                        column: x => x.idregion,
                        principalTable: "region",
                        principalColumn: "idregion",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "permettre",
                columns: table => new
                {
                    Idpermission = table.Column<int>(type: "integer", nullable: false),
                    Idrole = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_permettre", x => new { x.Idpermission, x.Idrole });
                    table.ForeignKey(
                        name: "FK_permettre_permission_Idpermission",
                        column: x => x.Idpermission,
                        principalTable: "permission",
                        principalColumn: "idpermission",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_permettre_role_Idrole",
                        column: x => x.Idrole,
                        principalTable: "role",
                        principalColumn: "idrole",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ville",
                columns: table => new
                {
                    idville = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    iddepartement = table.Column<int>(type: "integer", nullable: false),
                    codepostal = table.Column<string>(type: "character varying(5)", maxLength: 5, nullable: false),
                    nomville = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    taxedesejour = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ville", x => x.idville);
                    table.ForeignKey(
                        name: "FK_ville_departement_iddepartement",
                        column: x => x.iddepartement,
                        principalTable: "departement",
                        principalColumn: "iddepartement",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "adresse",
                columns: table => new
                {
                    idadresse = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idville = table.Column<int>(type: "integer", nullable: false),
                    numerorue = table.Column<int>(type: "integer", nullable: true),
                    nomrue = table.Column<string>(type: "character varying(39)", maxLength: 39, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_adresse", x => x.idadresse);
                    table.ForeignKey(
                        name: "FK_adresse_ville_idville",
                        column: x => x.idville,
                        principalTable: "ville",
                        principalColumn: "idville",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "annonce",
                columns: table => new
                {
                    idannonce = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idadresse = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    idheuredepart = table.Column<int>(type: "integer", nullable: false),
                    idtypehebergement = table.Column<int>(type: "integer", nullable: false),
                    idheurearrivee = table.Column<int>(type: "integer", nullable: false),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    titreannonce = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    descriptionannonce = table.Column<string>(type: "character varying(4000)", maxLength: 4000, nullable: false),
                    lienphoto = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                    nombreetoilesleboncoin = table.Column<int>(type: "integer", nullable: true),
                    montantacompte = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: true),
                    pourcentageacompte = table.Column<int>(type: "integer", nullable: true),
                    prixnuitee = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: false),
                    capacite = table.Column<int>(type: "integer", nullable: true),
                    nbchambres = table.Column<int>(type: "integer", nullable: true),
                    minimumnuitee = table.Column<int>(type: "integer", nullable: true),
                    possibiliteanimaux = table.Column<bool>(type: "boolean", nullable: false),
                    nombrebebesmax = table.Column<int>(type: "integer", nullable: true),
                    possibilitefumeur = table.Column<bool>(type: "boolean", nullable: false),
                    estverifie = table.Column<bool>(type: "boolean", nullable: false),
                    smsverifie = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_annonce", x => x.idannonce);
                    table.ForeignKey(
                        name: "FK_annonce_adresse_idadresse",
                        column: x => x.idadresse,
                        principalTable: "adresse",
                        principalColumn: "idadresse",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_annonce_date_iddate",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_annonce_heure_idheurearrivee",
                        column: x => x.idheurearrivee,
                        principalTable: "heure",
                        principalColumn: "idheure",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_annonce_heure_idheuredepart",
                        column: x => x.idheuredepart,
                        principalTable: "heure",
                        principalColumn: "idheure",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_annonce_typehebergement_idtypehebergement",
                        column: x => x.idtypehebergement,
                        principalTable: "typehebergement",
                        principalColumn: "idtypehebergement",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "AnnonceCommodite",
                columns: table => new
                {
                    Idannonce = table.Column<int>(type: "integer", nullable: false),
                    Idcommodite = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnnonceCommodite", x => new { x.Idannonce, x.Idcommodite });
                    table.ForeignKey(
                        name: "FK_AnnonceCommodite_annonce_Idannonce",
                        column: x => x.Idannonce,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AnnonceCommodite_commodite_Idcommodite",
                        column: x => x.Idcommodite,
                        principalTable: "commodite",
                        principalColumn: "idcommodite",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "relier",
                columns: table => new
                {
                    idannonce = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    estdisponible = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_relier", x => new { x.idannonce, x.iddate });
                    table.ForeignKey(
                        name: "FK_relier_annonce_idannonce",
                        column: x => x.idannonce,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_relier_date_iddate",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ressembler",
                columns: table => new
                {
                    IdannonceA = table.Column<int>(type: "integer", nullable: false),
                    IdannonceB = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ressembler", x => new { x.IdannonceA, x.IdannonceB });
                    table.ForeignKey(
                        name: "FK_ressembler_annonce_IdannonceA",
                        column: x => x.IdannonceA,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ressembler_annonce_IdannonceB",
                        column: x => x.IdannonceB,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AnnonceUtilisateur",
                columns: table => new
                {
                    Idannonce = table.Column<int>(type: "integer", nullable: false),
                    Idutilisateur = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnnonceUtilisateur", x => new { x.Idannonce, x.Idutilisateur });
                    table.ForeignKey(
                        name: "FK_AnnonceUtilisateur_annonce_Idannonce",
                        column: x => x.Idannonce,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "attribuer",
                columns: table => new
                {
                    Idrole = table.Column<int>(type: "integer", nullable: false),
                    Idutilisateur = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_attribuer", x => new { x.Idrole, x.Idutilisateur });
                    table.ForeignKey(
                        name: "FK_attribuer_role_Idrole",
                        column: x => x.Idrole,
                        principalTable: "role",
                        principalColumn: "idrole",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "avis",
                columns: table => new
                {
                    idavis = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idannonce = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    texteavis = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    nombreetoiles = table.Column<decimal>(type: "numeric(2,1)", precision: 2, scale: 1, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_avis", x => x.idavis);
                    table.ForeignKey(
                        name: "FK_avis_annonce_idannonce",
                        column: x => x.idannonce,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_avis_date_iddate",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "cartebancaire",
                columns: table => new
                {
                    idcartebancaire = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    nomtitulaire = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    prenomtitulaire = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    numerocartebancaire = table.Column<decimal>(type: "numeric(16,0)", precision: 16, scale: 0, nullable: true),
                    dateexpiration = table.Column<DateOnly>(type: "date", nullable: true),
                    numerocvv = table.Column<decimal>(type: "numeric(3,0)", precision: 3, scale: 0, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_cartebancaire", x => x.idcartebancaire);
                });

            migrationBuilder.CreateTable(
                name: "utilisateur",
                columns: table => new
                {
                    idutilisateur = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idadresse = table.Column<int>(type: "integer", nullable: false),
                    idcartebancaire = table.Column<int>(type: "integer", nullable: true),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    pseudonyme = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    email = table.Column<string>(type: "character varying(320)", maxLength: 320, nullable: false),
                    email_verified_at = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    password = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    telephoneutilisateur = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    phone_verified = table.Column<bool>(type: "boolean", nullable: false),
                    identity_verified = table.Column<bool>(type: "boolean", nullable: false),
                    solde = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: false),
                    remember_token = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    two_factor_secret = table.Column<string>(type: "text", nullable: true),
                    two_factor_recovery_codes = table.Column<string>(type: "text", nullable: true),
                    two_factor_confirmed_at = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    profile_photo_path = table.Column<string>(type: "character varying(2048)", maxLength: 2048, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_utilisateur", x => x.idutilisateur);
                    table.ForeignKey(
                        name: "FK_utilisateur_adresse_idadresse",
                        column: x => x.idadresse,
                        principalTable: "adresse",
                        principalColumn: "idadresse",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_utilisateur_cartebancaire_idcartebancaire",
                        column: x => x.idcartebancaire,
                        principalTable: "cartebancaire",
                        principalColumn: "idcartebancaire",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_utilisateur_date_iddate",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "message",
                columns: table => new
                {
                    idmessage = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idutilisateurreceveur = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    idutilisateurexpediteur = table.Column<int>(type: "integer", nullable: false),
                    contenumessage = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_message", x => x.idmessage);
                    table.ForeignKey(
                        name: "FK_message_date_iddate",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_message_utilisateur_idutilisateurexpediteur",
                        column: x => x.idutilisateurexpediteur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_message_utilisateur_idutilisateurreceveur",
                        column: x => x.idutilisateurreceveur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "particulier",
                columns: table => new
                {
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    nomutilisateur = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    prenomutilisateur = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    civilite = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_particulier", x => x.idutilisateur);
                    table.ForeignKey(
                        name: "FK_particulier_date_iddate",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_particulier_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "professionnel",
                columns: table => new
                {
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    numsiret = table.Column<decimal>(type: "numeric(14,0)", precision: 14, scale: 0, nullable: false),
                    nomsociete = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    secteuractivite = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_professionnel", x => x.idutilisateur);
                    table.ForeignKey(
                        name: "FK_professionnel_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "recherche",
                columns: table => new
                {
                    idrecherche = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    idville = table.Column<int>(type: "integer", nullable: true),
                    iddatefinrecherche = table.Column<int>(type: "integer", nullable: true),
                    iddepartement = table.Column<int>(type: "integer", nullable: true),
                    idregion = table.Column<int>(type: "integer", nullable: true),
                    iddatedebutrecherche = table.Column<int>(type: "integer", nullable: true),
                    paiementenligne = table.Column<bool>(type: "boolean", nullable: false),
                    capaciteminimumvoyageur = table.Column<int>(type: "integer", nullable: true),
                    prixminimum = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: true),
                    prixmaximum = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: true),
                    nombreminimumchambre = table.Column<int>(type: "integer", nullable: true),
                    nombremaximumchambre = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_recherche", x => x.idrecherche);
                    table.ForeignKey(
                        name: "FK_recherche_date_iddatedebutrecherche",
                        column: x => x.iddatedebutrecherche,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_recherche_date_iddatefinrecherche",
                        column: x => x.iddatefinrecherche,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_recherche_departement_iddepartement",
                        column: x => x.iddepartement,
                        principalTable: "departement",
                        principalColumn: "iddepartement",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_recherche_region_idregion",
                        column: x => x.idregion,
                        principalTable: "region",
                        principalColumn: "idregion",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_recherche_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_recherche_ville_idville",
                        column: x => x.idville,
                        principalTable: "ville",
                        principalColumn: "idville",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "reservation",
                columns: table => new
                {
                    idreservation = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idannonce = table.Column<int>(type: "integer", nullable: false),
                    iddatedebutreservation = table.Column<int>(type: "integer", nullable: false),
                    iddatefinreservation = table.Column<int>(type: "integer", nullable: false),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    nomclient = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    prenomclient = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    telephoneclient = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_reservation", x => x.idreservation);
                    table.ForeignKey(
                        name: "FK_reservation_annonce_idannonce",
                        column: x => x.idannonce,
                        principalTable: "annonce",
                        principalColumn: "idannonce",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_reservation_date_iddatedebutreservation",
                        column: x => x.iddatedebutreservation,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_reservation_date_iddatefinreservation",
                        column: x => x.iddatefinreservation,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_reservation_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "cibler",
                columns: table => new
                {
                    Idrecherche = table.Column<int>(type: "integer", nullable: false),
                    Idtypehebergement = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_cibler", x => new { x.Idrecherche, x.Idtypehebergement });
                    table.ForeignKey(
                        name: "FK_cibler_recherche_Idrecherche",
                        column: x => x.Idrecherche,
                        principalTable: "recherche",
                        principalColumn: "idrecherche",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_cibler_typehebergement_Idtypehebergement",
                        column: x => x.Idtypehebergement,
                        principalTable: "typehebergement",
                        principalColumn: "idtypehebergement",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "filtrer",
                columns: table => new
                {
                    Idcommodite = table.Column<int>(type: "integer", nullable: false),
                    Idrecherche = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_filtrer", x => new { x.Idcommodite, x.Idrecherche });
                    table.ForeignKey(
                        name: "FK_filtrer_commodite_Idcommodite",
                        column: x => x.Idcommodite,
                        principalTable: "commodite",
                        principalColumn: "idcommodite",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_filtrer_recherche_Idrecherche",
                        column: x => x.Idrecherche,
                        principalTable: "recherche",
                        principalColumn: "idrecherche",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "incident",
                columns: table => new
                {
                    idincident = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    idreservation = table.Column<int>(type: "integer", nullable: false),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    motifincident = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    descriptionincident = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                    lienphotoincident = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                    etape = table.Column<int>(type: "integer", nullable: true),
                    estclasse = table.Column<bool>(type: "boolean", nullable: true),
                    estrembourse = table.Column<bool>(type: "boolean", nullable: true),
                    estremisaucontentieux = table.Column<bool>(type: "boolean", nullable: true),
                    explicationproprietaire = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_incident", x => x.idincident);
                    table.ForeignKey(
                        name: "FK_incident_date_iddate",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_incident_reservation_idreservation",
                        column: x => x.idreservation,
                        principalTable: "reservation",
                        principalColumn: "idreservation",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_incident_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "inclure",
                columns: table => new
                {
                    idreservation = table.Column<int>(type: "integer", nullable: false),
                    idtypevoyageur = table.Column<int>(type: "integer", nullable: false),
                    nombrevoyageur = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_inclure", x => new { x.idreservation, x.idtypevoyageur });
                    table.ForeignKey(
                        name: "FK_inclure_reservation_idreservation",
                        column: x => x.idreservation,
                        principalTable: "reservation",
                        principalColumn: "idreservation",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_inclure_typevoyageur_idtypevoyageur",
                        column: x => x.idtypevoyageur,
                        principalTable: "typevoyageur",
                        principalColumn: "idtypevoyageur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "transaction",
                columns: table => new
                {
                    idtransaction = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    iddate = table.Column<int>(type: "integer", nullable: false),
                    idreservation = table.Column<int>(type: "integer", nullable: false),
                    idcartebancaire = table.Column<int>(type: "integer", nullable: false),
                    montanttransaction = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_transaction", x => x.idtransaction);
                    table.ForeignKey(
                        name: "FK_transaction_cartebancaire_idcartebancaire",
                        column: x => x.idcartebancaire,
                        principalTable: "cartebancaire",
                        principalColumn: "idcartebancaire",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_transaction_date_iddate",
                        column: x => x.iddate,
                        principalTable: "date",
                        principalColumn: "iddate",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_transaction_reservation_idreservation",
                        column: x => x.idreservation,
                        principalTable: "reservation",
                        principalColumn: "idreservation",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "demander",
                columns: table => new
                {
                    Idcompensation = table.Column<int>(type: "integer", nullable: false),
                    Idincident = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_demander", x => new { x.Idcompensation, x.Idincident });
                    table.ForeignKey(
                        name: "FK_demander_compensation_Idcompensation",
                        column: x => x.Idcompensation,
                        principalTable: "compensation",
                        principalColumn: "idcompensation",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_demander_incident_Idincident",
                        column: x => x.Idincident,
                        principalTable: "incident",
                        principalColumn: "idincident",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "idx_adresse_idville",
                table: "adresse",
                column: "idville");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_capacite",
                table: "annonce",
                column: "capacite");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_idadresse",
                table: "annonce",
                column: "idadresse");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_iddate",
                table: "annonce",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_idheurearrivee",
                table: "annonce",
                column: "idheurearrivee");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_idheuredepart",
                table: "annonce",
                column: "idheuredepart");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_idtypehebergement",
                table: "annonce",
                column: "idtypehebergement");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_idutilisateur",
                table: "annonce",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_nbchambres",
                table: "annonce",
                column: "nbchambres");

            migrationBuilder.CreateIndex(
                name: "idx_annonce_prixnuitee",
                table: "annonce",
                column: "prixnuitee");

            migrationBuilder.CreateIndex(
                name: "IX_AnnonceCommodite_Idcommodite",
                table: "AnnonceCommodite",
                column: "Idcommodite");

            migrationBuilder.CreateIndex(
                name: "IX_AnnonceUtilisateur_Idutilisateur",
                table: "AnnonceUtilisateur",
                column: "Idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_attribuer_Idutilisateur",
                table: "attribuer",
                column: "Idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_avis_idannonce",
                table: "avis",
                column: "idannonce");

            migrationBuilder.CreateIndex(
                name: "IX_avis_iddate",
                table: "avis",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "IX_avis_idutilisateur",
                table: "avis",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_cartebancaire_idutilisateur",
                table: "cartebancaire",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_cibler_Idtypehebergement",
                table: "cibler",
                column: "Idtypehebergement");

            migrationBuilder.CreateIndex(
                name: "idx_commodite_idcategorie",
                table: "commodite",
                column: "idcategorie");

            migrationBuilder.CreateIndex(
                name: "idx_date_date",
                table: "date",
                column: "date");

            migrationBuilder.CreateIndex(
                name: "IX_demander_Idincident",
                table: "demander",
                column: "Idincident");

            migrationBuilder.CreateIndex(
                name: "idx_departement_idregion",
                table: "departement",
                column: "idregion");

            migrationBuilder.CreateIndex(
                name: "IX_filtrer_Idrecherche",
                table: "filtrer",
                column: "Idrecherche");

            migrationBuilder.CreateIndex(
                name: "idx_incident_idreservation",
                table: "incident",
                column: "idreservation");

            migrationBuilder.CreateIndex(
                name: "idx_incident_idutilisateur",
                table: "incident",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_incident_iddate",
                table: "incident",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "idx_inclure_idtypevoyageur",
                table: "inclure",
                column: "idtypevoyageur");

            migrationBuilder.CreateIndex(
                name: "idx_message_idutilisateurexpediteur",
                table: "message",
                column: "idutilisateurexpediteur");

            migrationBuilder.CreateIndex(
                name: "idx_message_idutilisateurreceveur",
                table: "message",
                column: "idutilisateurreceveur");

            migrationBuilder.CreateIndex(
                name: "IX_message_iddate",
                table: "message",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "IX_particulier_iddate",
                table: "particulier",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "IX_permettre_Idrole",
                table: "permettre",
                column: "Idrole");

            migrationBuilder.CreateIndex(
                name: "professionnel_numsiret_key",
                table: "professionnel",
                column: "numsiret",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_recherche_iddatedebutrecherche",
                table: "recherche",
                column: "iddatedebutrecherche");

            migrationBuilder.CreateIndex(
                name: "IX_recherche_iddatefinrecherche",
                table: "recherche",
                column: "iddatefinrecherche");

            migrationBuilder.CreateIndex(
                name: "IX_recherche_iddepartement",
                table: "recherche",
                column: "iddepartement");

            migrationBuilder.CreateIndex(
                name: "IX_recherche_idregion",
                table: "recherche",
                column: "idregion");

            migrationBuilder.CreateIndex(
                name: "IX_recherche_idutilisateur",
                table: "recherche",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_recherche_idville",
                table: "recherche",
                column: "idville");

            migrationBuilder.CreateIndex(
                name: "region_nomregion_key",
                table: "region",
                column: "nomregion",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "idx_relier_iddate",
                table: "relier",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "idx_reservation_idannonce",
                table: "reservation",
                column: "idannonce");

            migrationBuilder.CreateIndex(
                name: "idx_reservation_iddatedebutres",
                table: "reservation",
                column: "iddatedebutreservation");

            migrationBuilder.CreateIndex(
                name: "idx_reservation_iddatefinres",
                table: "reservation",
                column: "iddatefinreservation");

            migrationBuilder.CreateIndex(
                name: "idx_reservation_idutilisateur",
                table: "reservation",
                column: "idutilisateur");

            migrationBuilder.CreateIndex(
                name: "IX_ressembler_IdannonceB",
                table: "ressembler",
                column: "IdannonceB");

            migrationBuilder.CreateIndex(
                name: "idx_transaction_idcartebancaire",
                table: "transaction",
                column: "idcartebancaire");

            migrationBuilder.CreateIndex(
                name: "idx_transaction_iddate",
                table: "transaction",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "idx_transaction_idreservation",
                table: "transaction",
                column: "idreservation");

            migrationBuilder.CreateIndex(
                name: "idx_typehebergement_idcategorie",
                table: "typehebergement",
                column: "idcategorie");

            migrationBuilder.CreateIndex(
                name: "typevoyageur_nomtypevoyageur_key",
                table: "typevoyageur",
                column: "nomtypevoyageur",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "idx_utilisateur_idadresse",
                table: "utilisateur",
                column: "idadresse");

            migrationBuilder.CreateIndex(
                name: "idx_utilisateur_idcartebancaire",
                table: "utilisateur",
                column: "idcartebancaire");

            migrationBuilder.CreateIndex(
                name: "idx_utilisateur_iddate",
                table: "utilisateur",
                column: "iddate");

            migrationBuilder.CreateIndex(
                name: "utilisateur_email_key",
                table: "utilisateur",
                column: "email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "utilisateur_telephoneutilisateur_key",
                table: "utilisateur",
                column: "telephoneutilisateur",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "idx_ville_iddepartement",
                table: "ville",
                column: "iddepartement");

            migrationBuilder.AddForeignKey(
                name: "FK_annonce_utilisateur_idutilisateur",
                table: "annonce",
                column: "idutilisateur",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_AnnonceUtilisateur_utilisateur_Idutilisateur",
                table: "AnnonceUtilisateur",
                column: "Idutilisateur",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_attribuer_utilisateur_Idutilisateur",
                table: "attribuer",
                column: "Idutilisateur",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_avis_utilisateur_idutilisateur",
                table: "avis",
                column: "idutilisateur",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_cartebancaire_utilisateur_idutilisateur",
                table: "cartebancaire",
                column: "idutilisateur",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_adresse_ville_idville",
                table: "adresse");

            migrationBuilder.DropForeignKey(
                name: "FK_utilisateur_adresse_idadresse",
                table: "utilisateur");

            migrationBuilder.DropForeignKey(
                name: "FK_utilisateur_date_iddate",
                table: "utilisateur");

            migrationBuilder.DropForeignKey(
                name: "FK_cartebancaire_utilisateur_idutilisateur",
                table: "cartebancaire");

            migrationBuilder.DropTable(
                name: "AnnonceCommodite");

            migrationBuilder.DropTable(
                name: "AnnonceUtilisateur");

            migrationBuilder.DropTable(
                name: "attribuer");

            migrationBuilder.DropTable(
                name: "avis");

            migrationBuilder.DropTable(
                name: "cibler");

            migrationBuilder.DropTable(
                name: "demander");

            migrationBuilder.DropTable(
                name: "filtrer");

            migrationBuilder.DropTable(
                name: "inclure");

            migrationBuilder.DropTable(
                name: "message");

            migrationBuilder.DropTable(
                name: "particulier");

            migrationBuilder.DropTable(
                name: "permettre");

            migrationBuilder.DropTable(
                name: "professionnel");

            migrationBuilder.DropTable(
                name: "relier");

            migrationBuilder.DropTable(
                name: "ressembler");

            migrationBuilder.DropTable(
                name: "transaction");

            migrationBuilder.DropTable(
                name: "compensation");

            migrationBuilder.DropTable(
                name: "incident");

            migrationBuilder.DropTable(
                name: "commodite");

            migrationBuilder.DropTable(
                name: "recherche");

            migrationBuilder.DropTable(
                name: "typevoyageur");

            migrationBuilder.DropTable(
                name: "permission");

            migrationBuilder.DropTable(
                name: "role");

            migrationBuilder.DropTable(
                name: "reservation");

            migrationBuilder.DropTable(
                name: "annonce");

            migrationBuilder.DropTable(
                name: "heure");

            migrationBuilder.DropTable(
                name: "typehebergement");

            migrationBuilder.DropTable(
                name: "categorie");

            migrationBuilder.DropTable(
                name: "ville");

            migrationBuilder.DropTable(
                name: "departement");

            migrationBuilder.DropTable(
                name: "region");

            migrationBuilder.DropTable(
                name: "adresse");

            migrationBuilder.DropTable(
                name: "date");

            migrationBuilder.DropTable(
                name: "utilisateur");

            migrationBuilder.DropTable(
                name: "cartebancaire");
        }
    }
}

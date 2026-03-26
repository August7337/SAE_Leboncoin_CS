using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace LeboncoinAPI.Migrations
{
    /// <inheritdoc />
    public partial class IncidentWorkflowHybridAuth : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("DELETE FROM attribuer WHERE idrole IN (1, 2);");

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 1, 1 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 2, 1 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 11, 1 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 12, 1 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 3, 2 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 8, 2 });

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "role",
                keyColumn: "idrole",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "role",
                keyColumn: "idrole",
                keyValue: 2);

            migrationBuilder.Sql(@"
DO $$
DECLARE
    selected_date_id integer;
    selected_address_id integer;
    location_user_id integer;
    compta_user_id integer;
    contentieux_user_id integer;
BEGIN
    SELECT MIN(iddate) INTO selected_date_id FROM date;
    IF selected_date_id IS NULL THEN
        INSERT INTO date (date) VALUES (CURRENT_DATE) RETURNING iddate INTO selected_date_id;
    END IF;

    SELECT MIN(idadresse) INTO selected_address_id FROM adresse;
    IF selected_address_id IS NULL THEN
        RAISE EXCEPTION 'Aucune adresse disponible pour creer les comptes de service.';
    END IF;

    INSERT INTO utilisateur (
        idadresse, iddate, pseudonyme, email, email_verified_at, password,
        telephoneutilisateur, phone_verified, identity_verified, solde,
        remember_token, two_factor_secret, two_factor_recovery_codes, two_factor_confirmed_at
    )
    VALUES (
        selected_address_id, selected_date_id, 'svc_location', 'service.location@leboncoin.local', NOW(), '$2a$11$TLEucTKy3A3Zn3C6x4Wgy.SLEXObaeIMvQ88mR.2MSwTibscWXGCq',
        '0600000051', TRUE, TRUE, 0,
        NULL, NULL, NULL, NULL
    )
    ON CONFLICT (email) DO NOTHING;

    INSERT INTO utilisateur (
        idadresse, iddate, pseudonyme, email, email_verified_at, password,
        telephoneutilisateur, phone_verified, identity_verified, solde,
        remember_token, two_factor_secret, two_factor_recovery_codes, two_factor_confirmed_at
    )
    VALUES (
        selected_address_id, selected_date_id, 'svc_compta', 'service.comptabilite@leboncoin.local', NOW(), '$2a$11$TLEucTKy3A3Zn3C6x4Wgy.SLEXObaeIMvQ88mR.2MSwTibscWXGCq',
        '0600000052', TRUE, TRUE, 0,
        NULL, NULL, NULL, NULL
    )
    ON CONFLICT (email) DO NOTHING;

    INSERT INTO utilisateur (
        idadresse, iddate, pseudonyme, email, email_verified_at, password,
        telephoneutilisateur, phone_verified, identity_verified, solde,
        remember_token, two_factor_secret, two_factor_recovery_codes, two_factor_confirmed_at
    )
    VALUES (
        selected_address_id, selected_date_id, 'svc_contentieux', 'service.contentieux@leboncoin.local', NOW(), '$2a$11$TLEucTKy3A3Zn3C6x4Wgy.SLEXObaeIMvQ88mR.2MSwTibscWXGCq',
        '0600000053', TRUE, TRUE, 0,
        NULL, NULL, NULL, NULL
    )
    ON CONFLICT (email) DO NOTHING;

    SELECT idutilisateur INTO location_user_id FROM utilisateur WHERE email = 'service.location@leboncoin.local';
    SELECT idutilisateur INTO compta_user_id FROM utilisateur WHERE email = 'service.comptabilite@leboncoin.local';
    SELECT idutilisateur INTO contentieux_user_id FROM utilisateur WHERE email = 'service.contentieux@leboncoin.local';

    INSERT INTO attribuer (idutilisateur, idrole) VALUES (location_user_id, 3) ON CONFLICT DO NOTHING;
    INSERT INTO attribuer (idutilisateur, idrole) VALUES (compta_user_id, 4) ON CONFLICT DO NOTHING;
    INSERT INTO attribuer (idutilisateur, idrole) VALUES (contentieux_user_id, 5) ON CONFLICT DO NOTHING;
END $$;
");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
DELETE FROM attribuer
WHERE idutilisateur IN (
    SELECT idutilisateur
    FROM utilisateur
    WHERE email IN (
        'service.location@leboncoin.local',
        'service.comptabilite@leboncoin.local',
        'service.contentieux@leboncoin.local'
    )
);

DELETE FROM utilisateur
WHERE email IN (
    'service.location@leboncoin.local',
    'service.comptabilite@leboncoin.local',
    'service.contentieux@leboncoin.local'
);
");

            migrationBuilder.InsertData(
                table: "permission",
                columns: new[] { "idpermission", "nompermission" },
                values: new object[,]
                {
                    { 1, "incident.create" },
                    { 2, "incident.read.own" },
                    { 3, "incident.read.property" },
                    { 8, "incident.submit_owner_explanation" },
                    { 11, "incident.accept_refusal" },
                    { 12, "incident.contest_refusal" }
                });

            migrationBuilder.InsertData(
                table: "role",
                columns: new[] { "idrole", "nomrole" },
                values: new object[,]
                {
                    { 1, "Locataire" },
                    { 2, "Proprietaire" }
                });

            migrationBuilder.InsertData(
                table: "permettre",
                columns: new[] { "idpermission", "idrole" },
                values: new object[,]
                {
                    { 1, 1 },
                    { 2, 1 },
                    { 11, 1 },
                    { 12, 1 },
                    { 3, 2 },
                    { 8, 2 }
                });

            migrationBuilder.Sql(@"
INSERT INTO attribuer (idutilisateur, idrole)
SELECT idutilisateur, 1 FROM particulier
ON CONFLICT DO NOTHING;

INSERT INTO attribuer (idutilisateur, idrole)
SELECT idutilisateur, 2 FROM professionnel
ON CONFLICT DO NOTHING;
");
        }
    }
}

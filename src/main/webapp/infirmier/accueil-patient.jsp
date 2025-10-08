<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  if (session == null || session.getAttribute("user") == null ||
          !"INFIRMIER".equals(session.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Accueil Patient - Système Médical</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

    * {
      font-family: 'Inter', sans-serif;
    }

    .input-field {
      transition: all 0.3s ease;
    }

    .input-field:focus {
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(20, 108, 92, 0.15);
    }

    .form-section {
      display: none;
    }

    .form-section.active {
      display: block;
    }

    .btn-primary {
      background: linear-gradient(135deg, #146c5c 0%, #0f5449 100%);
      transition: all 0.3s ease;
    }

    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 20px rgba(20, 108, 92, 0.3);
    }
  </style>
</head>
<body class="bg-gray-50">

<!-- Navbar -->
<nav class="bg-gradient-to-r from-teal-700 to-teal-900 shadow-lg">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between items-center h-16">
      <div class="flex items-center">
        <a href="dashboard-infirmier" class="text-white hover:text-gray-200 mr-4">
          <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
          </svg>
        </a>
        <h1 class="text-xl font-bold text-white">Accueil Patient</h1>
      </div>

      <div class="flex items-center space-x-4">
        <span class="text-white">${sessionScope.user}</span>
        <a href="logout" class="bg-white text-teal-700 px-4 py-2 rounded-lg hover:bg-gray-100 transition font-semibold">
          Déconnexion
        </a>
      </div>
    </div>
  </div>
</nav>

<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

  <!-- Étape 1: Recherche du patient -->
  <div id="searchSection" class="bg-white rounded-xl shadow-lg p-6 mb-6">
    <h2 class="text-2xl font-bold text-gray-900 mb-6">
      <svg class="inline h-7 w-7 mr-2 text-teal-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
      </svg>
      Étape 1 : Rechercher le patient
    </h2>

    <!-- Message d'erreur ou succès -->
    <c:if test="${not empty error}">
      <div class="mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded-lg">
          ${error}
      </div>
    </c:if>

    <c:if test="${not empty success}">
      <div class="mb-4 p-3 bg-green-100 border border-green-400 text-green-700 rounded-lg">
          ${success}
      </div>
    </c:if>

    <form action="infirmier/rechercher-patient" method="post" class="mb-6">
      <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
      <div class="flex gap-4">
        <div class="flex-1">
          <input
                  type="text"
                  name="numeroSecuriteSociale"
                  id="numeroSecuriteSociale"
                  placeholder="Numéro de sécurité sociale"
                  class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                  pattern="[0-9]{13,15}"
                  title="Le numéro de sécurité sociale doit contenir 13 à 15 chiffres"
                  required
          />
        </div>
        <button
                type="submit"
                class="btn-primary text-white px-6 py-3 rounded-xl font-semibold focus:outline-none"
        >
          Rechercher
        </button>
      </div>
    </form>

    <!-- Patient trouvé -->
    <c:if test="${not empty patientTrouve}">
      <div class="border-t pt-6">
        <div class="bg-green-50 border-2 border-green-200 rounded-xl p-6">
          <h3 class="text-lg font-bold text-green-900 mb-4">Patient trouvé !</h3>
          <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
              <p class="text-sm text-gray-600">Nom complet</p>
              <p class="font-semibold">${patientTrouve.nom} ${patientTrouve.prenom}</p>
            </div>
            <div>
              <p class="text-sm text-gray-600">Date de naissance</p>
              <p class="font-semibold">${patientTrouve.dateNaissance}</p>
            </div>
            <div>
              <p class="text-sm text-gray-600">Téléphone</p>
              <p class="font-semibold">${patientTrouve.telephone}</p>
            </div>
            <div>
              <p class="text-sm text-gray-600">Numéro SS</p>
              <p class="font-semibold">${patientTrouve.numeroSecuriteSociale}</p>
            </div>
          </div>
          <button
                  onclick="showSignesVitauxForm()"
                  class="btn-primary text-white px-6 py-3 rounded-xl font-semibold"
          >
            Enregistrer les signes vitaux
          </button>
        </div>
      </div>
    </c:if>

    <!-- Bouton nouveau patient -->
    <div class="text-center mt-6">
      <button
              onclick="showNewPatientForm()"
              class="bg-gray-100 text-gray-700 px-6 py-3 rounded-xl font-semibold hover:bg-gray-200 transition"
      >
        + Nouveau patient
      </button>
    </div>
  </div>

  <!-- Formulaire nouveau patient -->
  <div id="newPatientSection" class="form-section bg-white rounded-xl shadow-lg p-6 mb-6">
    <h2 class="text-2xl font-bold text-gray-900 mb-6">
      <svg class="inline h-7 w-7 mr-2 text-teal-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/>
      </svg>
      Étape 2 : Enregistrer un nouveau patient
    </h2>

    <form action="ajouter-patient.jsp" method="post">
      <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

      <!-- Informations personnelles -->
      <div class="mb-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-4 border-b pb-2">Informations personnelles</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label for="nom" class="block text-sm font-semibold text-gray-700 mb-2">
              Nom <span class="text-red-500">*</span>
            </label>
            <input
                    type="text"
                    id="nom"
                    name="nom"
                    required
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="Nom du patient"
            />
          </div>

          <div>
            <label for="prenom" class="block text-sm font-semibold text-gray-700 mb-2">
              Prénom <span class="text-red-500">*</span>
            </label>
            <input
                    type="text"
                    id="prenom"
                    name="prenom"
                    required
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="Prénom du patient"
            />
          </div>

          <div>
            <label for="dateNaissance" class="block text-sm font-semibold text-gray-700 mb-2">
              Date de naissance <span class="text-red-500">*</span>
            </label>
            <input
                    type="date"
                    id="dateNaissance"
                    name="dateNaissance"
                    required
                    max="2025-10-08"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
            />
          </div>

          <div>
            <label for="numeroSecuriteSocialeNew" class="block text-sm font-semibold text-gray-700 mb-2">
              Numéro de sécurité sociale <span class="text-red-500">*</span>
            </label>
            <input
                    type="text"
                    id="numeroSecuriteSocialeNew"
                    name="numeroSecuriteSociale"
                    required
                    pattern="[0-9]{13,15}"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="Ex: 1234567890123"
            />
          </div>

          <div>
            <label for="telephone" class="block text-sm font-semibold text-gray-700 mb-2">
              Téléphone
            </label>
            <input
                    type="tel"
                    id="telephone"
                    name="telephone"
                    pattern="[0-9]{10}"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="0612345678"
            />
          </div>

          <div>
            <label for="mutuelle" class="block text-sm font-semibold text-gray-700 mb-2">
              Mutuelle
            </label>
            <input
                    type="text"
                    id="mutuelle"
                    name="mutuelle"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="Nom de la mutuelle"
            />
          </div>
        </div>

        <div class="mt-4">
          <label for="adresse" class="block text-sm font-semibold text-gray-700 mb-2">
            Adresse
          </label>
          <textarea
                  id="adresse"
                  name="adresse"
                  rows="2"
                  class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                  placeholder="Adresse complète"
          ></textarea>
        </div>
      </div>

      <!-- Informations médicales -->
      <div class="mb-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-4 border-b pb-2">Informations médicales</h3>
        <div class="space-y-4">
          <div>
            <label for="antecedents" class="block text-sm font-semibold text-gray-700 mb-2">
              Antécédents médicaux
            </label>
            <textarea
                    id="antecedents"
                    name="antecedents"
                    rows="3"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="Maladies antérieures, opérations chirurgicales..."
            ></textarea>
          </div>

          <div>
            <label for="allergies" class="block text-sm font-semibold text-gray-700 mb-2">
              Allergies connues
            </label>
            <textarea
                    id="allergies"
                    name="allergies"
                    rows="2"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="Allergies alimentaires, médicamenteuses..."
            ></textarea>
          </div>

          <div>
            <label for="traitementsEnCours" class="block text-sm font-semibold text-gray-700 mb-2">
              Traitements en cours
            </label>
            <textarea
                    id="traitementsEnCours"
                    name="traitementsEnCours"
                    rows="2"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="Médicaments actuellement pris..."
            ></textarea>
          </div>
        </div>
      </div>

      <!-- Signes vitaux -->
      <div class="mb-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-4 border-b pb-2">Signes vitaux</h3>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label for="tensionArterielle" class="block text-sm font-semibold text-gray-700 mb-2">
              Tension artérielle <span class="text-red-500">*</span>
            </label>
            <input
                    type="text"
                    id="tensionArterielle"
                    name="tensionArterielle"
                    required
                    pattern="[0-9]{2,3}/[0-9]{2,3}"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="120/80"
            />
            <p class="text-xs text-gray-500 mt-1">Format: systolique/diastolique</p>
          </div>

          <div>
            <label for="frequenceCardiaque" class="block text-sm font-semibold text-gray-700 mb-2">
              Fréquence cardiaque <span class="text-red-500">*</span>
            </label>
            <div class="relative">
              <input
                      type="number"
                      id="frequenceCardiaque"
                      name="frequenceCardiaque"
                      required
                      min="30"
                      max="220"
                      class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                      placeholder="70"
              />
              <span class="absolute right-4 top-3.5 text-gray-500">bpm</span>
            </div>
          </div>

          <div>
            <label for="temperature" class="block text-sm font-semibold text-gray-700 mb-2">
              Température <span class="text-red-500">*</span>
            </label>
            <div class="relative">
              <input
                      type="number"
                      id="temperature"
                      name="temperature"
                      required
                      min="35"
                      max="42"
                      step="0.1"
                      class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                      placeholder="37.0"
              />
              <span class="absolute right-4 top-3.5 text-gray-500">°C</span>
            </div>
          </div>

          <div>
            <label for="frequenceRespiratoire" class="block text-sm font-semibold text-gray-700 mb-2">
              Fréquence respiratoire <span class="text-red-500">*</span>
            </label>
            <div class="relative">
              <input
                      type="number"
                      id="frequenceRespiratoire"
                      name="frequenceRespiratoire"
                      required
                      min="8"
                      max="40"
                      class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                      placeholder="16"
              />
              <span class="absolute right-4 top-3.5 text-gray-500">/min</span>
            </div>
          </div>

          <div>
            <label for="poids" class="block text-sm font-semibold text-gray-700 mb-2">
              Poids
            </label>
            <div class="relative">
              <input
                      type="number"
                      id="poids"
                      name="poids"
                      min="1"
                      max="300"
                      step="0.1"
                      class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                      placeholder="70.5"
              />
              <span class="absolute right-4 top-3.5 text-gray-500">kg</span>
            </div>
          </div>

          <div>
            <label for="taille" class="block text-sm font-semibold text-gray-700 mb-2">
              Taille
            </label>
            <div class="relative">
              <input
                      type="number"
                      id="taille"
                      name="taille"
                      min="50"
                      max="250"
                      step="0.1"
                      class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                      placeholder="175"
              />
              <span class="absolute right-4 top-3.5 text-gray-500">cm</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Boutons d'action -->
      <div class="flex justify-end space-x-4">
        <button
                type="button"
                onclick="hideNewPatientForm()"
                class="bg-gray-200 text-gray-700 px-6 py-3 rounded-xl font-semibold hover:bg-gray-300 transition"
        >
          Annuler
        </button>
        <button
                type="submit"
                class="btn-primary text-white px-6 py-3 rounded-xl font-semibold"
        >
          Enregistrer et ajouter à la file d'attente
        </button>
      </div>
    </form>
  </div>

  <!-- Formulaire signes vitaux pour patient existant -->
  <div id="signesVitauxSection" class="form-section bg-white rounded-xl shadow-lg p-6">
    <h2 class="text-2xl font-bold text-gray-900 mb-6">
      <svg class="inline h-7 w-7 mr-2 text-teal-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
      </svg>
      Étape 3 : Enregistrer les signes vitaux
    </h2>

    <form action="infirmier/ajouter-signes-vitaux" method="post">
      <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
      <input type="hidden" name="patientId" value="${patientTrouve.id}"/>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div>
          <label for="tensionArterielle2" class="block text-sm font-semibold text-gray-700 mb-2">
            Tension artérielle <span class="text-red-500">*</span>
          </label>
          <input
                  type="text"
                  id="tensionArterielle2"
                  name="tensionArterielle"
                  required
                  pattern="[0-9]{2,3}/[0-9]{2,3}"
                  class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                  placeholder="120/80"
          />
        </div>

        <div>
          <label for="frequenceCardiaque2" class="block text-sm font-semibold text-gray-700 mb-2">
            Fréquence cardiaque <span class="text-red-500">*</span>
          </label>
          <div class="relative">
            <input
                    type="number"
                    id="frequenceCardiaque2"
                    name="frequenceCardiaque"
                    required
                    min="30"
                    max="220"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="70"
            />
            <span class="absolute right-4 top-3.5 text-gray-500">bpm</span>
          </div>
        </div>

        <div>
          <label for="temperature2" class="block text-sm font-semibold text-gray-700 mb-2">
            Température <span class="text-red-500">*</span>
          </label>
          <div class="relative">
            <input
                    type="number"
                    id="temperature2"
                    name="temperature"
                    required
                    min="35"
                    max="42"
                    step="0.1"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="37.0"
            />
            <span class="absolute right-4 top-3.5 text-gray-500">°C</span>
          </div>
        </div>

        <div>
          <label for="frequenceRespiratoire2" class="block text-sm font-semibold text-gray-700 mb-2">
            Fréquence respiratoire <span class="text-red-500">*</span>
          </label>
          <div class="relative">
            <input
                    type="number"
                    id="frequenceRespiratoire2"
                    name="frequenceRespiratoire"
                    required
                    min="8"
                    max="40"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="16"
            />
            <span class="absolute right-4 top-3.5 text-gray-500">/min</span>
          </div>
        </div>

        <div>
          <label for="poids2" class="block text-sm font-semibold text-gray-700 mb-2">
            Poids
          </label>
          <div class="relative">
            <input
                    type="number"
                    id="poids2"
                    name="poids"
                    min="1"
                    max="300"
                    step="0.1"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="70.5"
            />
            <span class="absolute right-4 top-3.5 text-gray-500">kg</span>
          </div>
        </div>

        <div>
          <label for="taille2" class="block text-sm font-semibold text-gray-700 mb-2">
            Taille
          </label>
          <div class="relative">
            <input
                    type="number"
                    id="taille2"
                    name="taille"
                    min="50"
                    max="250"
                    step="0.1"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700"
                    placeholder="175"
            />
            <span class="absolute right-4 top-3.5 text-gray-500">cm</span>
          </div>
        </div>
      </div>

      <div class="flex justify-end space-x-4">
        <button
                type="button"
                onclick="hideSignesVitauxForm()"
                class="bg-gray-200 text-gray-700 px-6 py-3 rounded-xl font-semibold hover:bg-gray-300 transition"
        >
          Annuler
        </button>
        <button
                type="submit"
                class="btn-primary text-white px-6 py-3 rounded-xl font-semibold"
        >
          Enregistrer et ajouter à la file d'attente
        </button>
      </div>
    </form>
  </div>

</div>

<script>
  function showNewPatientForm() {
    document.getElementById('newPatientSection').classList.add('active');
    document.getElementById('searchSection').style.display = 'none';
  }

  function hideNewPatientForm() {
    document.getElementById('newPatientSection').classList.remove('active');
    document.getElementById('searchSection').style.display = 'block';
  }

  function showSignesVitauxForm() {
    document.getElementById('signesVitauxSection').classList.add('active');
    document.getElementById('searchSection').style.display = 'none';
  }

  function hideSignesVitauxForm() {
    document.getElementById('signesVitauxSection').classList.remove('active');
    document.getElementById('searchSection').style.display = 'block';
  }
</script>

</body>
</html>

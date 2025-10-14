<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  if (session == null || session.getAttribute("user") == null ||
          !"GENERALISTE".equals(session.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Demander une Expertise - Télé-expertise Médicale</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
    * { font-family: 'Inter', sans-serif; }
    .input-field { transition: all 0.3s ease; }
    .input-field:focus { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(37, 99, 235, 0.15); }
    .step { opacity: 0.5; }
    .step.active { opacity: 1; }
    .creneau-card { transition: all 0.2s; }
    .creneau-card:hover:not(.disabled) { transform: translateY(-2px); }
    .specialiste-card { cursor: pointer; border: 2px solid transparent; transition: all 0.3s; }
    .specialiste-card:hover { border-color: #3b82f6; transform: translateY(-2px); }
    .specialiste-card.selected { border-color: #2563eb; background-color: #eff6ff; }
    .specialite-card { cursor: pointer; border: 2px solid transparent; transition: all 0.3s; }
    .specialite-card:hover { border-color: #3b82f6; transform: translateY(-2px); }
    .specialite-card.selected { border-color: #2563eb; background-color: #eff6ff; }
  </style>
</head>
<body class="bg-gray-50">

<!-- Navbar -->
<nav class="bg-gradient-to-r from-blue-700 to-blue-900 shadow-lg">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between items-center h-16">
      <div class="flex items-center">
        <a href="${pageContext.request.contextPath}/generaliste/dashboard-generaliste"
           class="text-white hover:text-gray-200 mr-4">
          <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
          </svg>
        </a>
        <h1 class="text-xl font-bold text-white">Demander une Expertise Médicale</h1>
      </div>
      <div class="flex items-center space-x-4">
        <span class="text-white">Dr. ${sessionScope.user}</span>
        <a href="${pageContext.request.contextPath}/logout"
           class="bg-white text-blue-700 px-4 py-2 rounded-lg hover:bg-gray-100 transition font-semibold">
          Déconnexion
        </a>
      </div>
    </div>
  </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

  <!-- Messages -->
  <c:if test="${not empty sessionScope.error}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-6 flex items-center">
      <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
      </svg>
        ${sessionScope.error}
    </div>
    <c:remove var="error" scope="session"/>
  </c:if>

  <c:if test="${not empty sessionScope.info}">
    <div class="bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded-lg mb-6 flex items-center">
      <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
      </svg>
        ${sessionScope.info}
    </div>
    <c:remove var="info" scope="session"/>
  </c:if>

  <!-- Processus en étapes -->
  <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
    <div class="flex items-center justify-between">
      <div class="flex items-center step active">
        <div class="flex items-center justify-center w-10 h-10 bg-blue-600 text-white rounded-full font-bold">1</div>
        <span class="ml-2 font-semibold text-gray-700">Spécialité</span>
      </div>
      <div class="flex-1 h-1 bg-gray-300 mx-4"></div>
      <div class="flex items-center step ${not empty specialistes ? 'active' : ''}">
        <div class="flex items-center justify-center w-10 h-10 ${not empty specialistes ? 'bg-blue-600 text-white' : 'bg-gray-300 text-gray-600'} rounded-full font-bold">2</div>
        <span class="ml-2 font-semibold text-gray-700">Spécialiste</span>
      </div>
      <div class="flex-1 h-1 bg-gray-300 mx-4"></div>
      <div class="flex items-center step ${not empty creneaux ? 'active' : ''}">
        <div class="flex items-center justify-center w-10 h-10 ${not empty creneaux ? 'bg-blue-600 text-white' : 'bg-gray-300 text-gray-600'} rounded-full font-bold">3</div>
        <span class="ml-2 font-semibold text-gray-700">Créneau</span>
      </div>
      <div class="flex-1 h-1 bg-gray-300 mx-4"></div>
      <div class="flex items-center step">
        <div class="flex items-center justify-center w-10 h-10 bg-gray-300 text-gray-600 rounded-full font-bold">4</div>
        <span class="ml-2 font-semibold text-gray-700">Détails</span>
      </div>
    </div>
  </div>

  <!-- Informations patient -->
  <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
    <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
      <svg class="w-6 h-6 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
      </svg>
      Patient concerné
    </h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div>
        <p class="text-sm text-gray-600">Nom complet</p>
        <p class="font-semibold">${consultation.patient.nom} ${consultation.patient.prenom}</p>
      </div>
      <div>
        <p class="text-sm text-gray-600">Motif de consultation</p>
        <p class="font-semibold">${consultation.motif}</p>
      </div>
      <div>
        <p class="text-sm text-gray-600">Observations</p>
        <p class="text-sm text-gray-700">${consultation.observations}</p>
      </div>
    </div>
  </div>

  <!-- Étape 1: Sélection de la spécialité -->
  <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
    <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
      <div class="flex items-center justify-center w-8 h-8 bg-blue-600 text-white rounded-full font-bold mr-3">1</div>
      Sélectionner une spécialité médicale
    </h2>

    <form method="get" action="${pageContext.request.contextPath}/generaliste/demander-expertise">
      <input type="hidden" name="consultationId" value="${consultation.id}"/>

      <c:choose>
        <c:when test="${not empty specialites}">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <c:forEach items="${specialites}" var="specialite">
              <label class="specialite-card p-4 border-2 rounded-lg ${specialiteSelectionnee == specialite.id ? 'selected' : ''}">
                <input type="radio" name="specialiteId" value="${specialite.id}"
                  ${specialiteSelectionnee == specialite.id ? 'checked' : ''}
                       onchange="this.form.submit()" class="hidden"/>
                <div class="text-center">
                  <p class="font-semibold text-gray-900">${specialite.nom}</p>
                </div>
              </label>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <div class="text-center py-8 text-gray-500">
            <svg class="mx-auto h-12 w-12 text-gray-400 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
            </svg>
            <p>Aucune spécialité disponible. Veuillez contacter l'administrateur.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </form>
  </div>

  <!-- Étape 2: Liste des spécialistes filtrés -->
  <c:if test="${not empty specialistes}">
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
      <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
        <div class="flex items-center justify-center w-8 h-8 bg-blue-600 text-white rounded-full font-bold mr-3">2</div>
        Spécialistes disponibles (triés par tarif)
      </h2>

      <p class="text-sm text-gray-600 mb-4">
        <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        Les spécialistes sont triés du moins cher au plus cher
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <c:forEach items="${specialistes}" var="specialiste">
          <a href="${pageContext.request.contextPath}/generaliste/demander-expertise?consultationId=${consultation.id}&specialiteId=${specialiteSelectionnee}&specialisteId=${specialiste.id}"
             class="specialiste-card block p-4 border-2 rounded-lg ${specialisteSelectionne.id == specialiste.id ? 'selected' : ''}">
            <div class="flex items-center justify-between">
              <div class="flex items-center">
                <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                                    <span class="text-blue-700 font-bold text-lg">
                                        ${specialiste.prenom.substring(0,1)}${specialiste.nom.substring(0,1)}
                                    </span>
                </div>
                <div class="ml-4">
                  <p class="font-bold text-gray-900">Dr. ${specialiste.nom} ${specialiste.prenom}</p>
                  <p class="text-sm text-gray-600">${specialiste.specialite.nom}</p>
                  <c:if test="${specialiste.disponible}">
                                        <span class="inline-flex items-center px-2 py-1 text-xs font-semibold text-green-700 bg-green-100 rounded-full mt-1">
                                            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                <circle cx="10" cy="10" r="5"/>
                                            </svg>
                                            Disponible
                                        </span>
                  </c:if>
                </div>
              </div>
              <div class="text-right">
                <p class="text-2xl font-bold text-blue-600">${specialiste.tarif} DH</p>
                <p class="text-xs text-gray-500">par consultation</p>
              </div>
            </div>
          </a>
        </c:forEach>
      </div>

      <c:if test="${empty specialistes}">
        <div class="text-center py-8 text-gray-500">
          <svg class="mx-auto h-12 w-12 text-gray-400 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
          </svg>
          <p>Aucun spécialiste disponible pour cette spécialité</p>
        </div>
      </c:if>
    </div>
  </c:if>

  <!-- Étape 3: Créneaux disponibles -->
  <c:if test="${not empty creneaux}">
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
      <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
        <div class="flex items-center justify-center w-8 h-8 bg-blue-600 text-white rounded-full font-bold mr-3">3</div>
        Créneaux disponibles - Dr. ${specialisteSelectionne.nom} ${specialisteSelectionne.prenom}
      </h2>

      <p class="text-sm text-gray-600 mb-4">
        <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        Durée de consultation : 30 minutes
      </p>

      <div class="grid grid-cols-2 md:grid-cols-4 gap-3" id="creneauxContainer">
        <c:forEach items="${creneaux}" var="creneau">
          <label class="creneau-card block p-4 border-2 rounded-lg cursor-pointer ${creneau.disponible ? 'border-green-200 bg-green-50 hover:border-blue-500' : 'border-gray-200 bg-gray-100 opacity-50 cursor-not-allowed disabled'}">
            <input type="radio" name="creneauSelected" value="${creneau.id}"
              ${creneau.disponible ? '' : 'disabled'}
                   class="hidden creneau-radio"/>
            <div class="text-center">
              <p class="font-bold text-gray-900">
                <fmt:parseDate value="${creneau.dateHeure}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/>
              </p>
              <p class="text-2xl font-bold ${creneau.disponible ? 'text-blue-600' : 'text-gray-400'} my-2">
                <fmt:formatDate value="${parsedDate}" pattern="HH:mm"/>
              </p>
              <c:choose>
                <c:when test="${creneau.disponible}">
                                    <span class="inline-flex items-center px-2 py-1 text-xs font-semibold text-green-700 bg-green-100 rounded-full">
                                        <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                                        </svg>
                                        Disponible
                                    </span>
                </c:when>
                <c:otherwise>
                                    <span class="inline-flex items-center px-2 py-1 text-xs font-semibold text-gray-600 bg-gray-200 rounded-full">
                                        <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                                        </svg>
                                        Réservé
                                    </span>
                </c:otherwise>
              </c:choose>
            </div>
          </label>
        </c:forEach>
      </div>

      <c:if test="${empty creneaux}">
        <div class="text-center py-8 text-gray-500">
          <svg class="mx-auto h-12 w-12 text-gray-400 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          <p>Aucun créneau disponible pour ce spécialiste</p>
        </div>
      </c:if>
    </div>

    <!-- Étape 4: Formulaire de demande -->
    <form id="expertiseForm" method="post" action="${pageContext.request.contextPath}/generaliste/demander-expertise">
      <input type="hidden" name="consultationId" value="${consultation.id}"/>
      <input type="hidden" name="specialisteId" value="${specialisteSelectionne.id}"/>
      <input type="hidden" name="creneauId" id="creneauIdField" value=""/>

      <div class="bg-white rounded-xl shadow-lg p-6">
        <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
          <div class="flex items-center justify-center w-8 h-8 bg-blue-600 text-white rounded-full font-bold mr-3">4</div>
          Détails de la demande d'expertise
        </h2>

        <div class="space-y-6">
          <!-- Question -->
          <div>
            <label for="question" class="block text-sm font-semibold text-gray-700 mb-2">
              Question au spécialiste <span class="text-red-500">*</span>
            </label>
            <textarea
                    id="question"
                    name="question"
                    required
                    rows="4"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-blue-600"
                    placeholder="Posez votre question au spécialiste concernant le diagnostic, l'analyse ou la stratégie thérapeutique..."></textarea>
            <p class="text-xs text-gray-500 mt-1">Soyez précis dans votre demande d'avis d'expert</p>
          </div>

          <!-- Données et analyses -->
          <div>
            <label for="donneesAnalyses" class="block text-sm font-semibold text-gray-700 mb-2">
              Données et analyses complémentaires
            </label>
            <textarea
                    id="donneesAnalyses"
                    name="donneesAnalyses"
                    rows="4"
                    class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-blue-600"
                    placeholder="Résultats d'examens, analyses biologiques, imagerie médicale..."></textarea>
            <p class="text-xs text-gray-500 mt-1">Fournissez toutes les informations pertinentes pour faciliter l'expertise</p>
          </div>

          <!-- Priorité -->
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-2">
              Niveau de priorité <span class="text-red-500">*</span>
            </label>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
              <label class="flex items-center p-4 border-2 border-gray-200 rounded-lg cursor-pointer hover:border-red-500">
                <input type="radio" name="priorite" value="URGENTE" required class="w-4 h-4 text-red-600"/>
                <div class="ml-3">
                  <p class="font-semibold text-red-600">URGENTE</p>
                  <p class="text-xs text-gray-500">Réponse sous 24h</p>
                </div>
              </label>

              <label class="flex items-center p-4 border-2 border-gray-200 rounded-lg cursor-pointer hover:border-blue-500">
                <input type="radio" name="priorite" value="NORMALE" required class="w-4 h-4 text-blue-600"/>
                <div class="ml-3">
                  <p class="font-semibold text-blue-600">NORMALE</p>
                  <p class="text-xs text-gray-500">Réponse sous 48h</p>
                </div>
              </label>

              <label class="flex items-center p-4 border-2 border-gray-200 rounded-lg cursor-pointer hover:border-gray-500">
                <input type="radio" name="priorite" value="NON_URGENTE" required class="w-4 h-4 text-gray-600"/>
                <div class="ml-3">
                  <p class="font-semibold text-gray-600">NON URGENTE</p>
                  <p class="text-xs text-gray-500">Réponse sous 72h</p>
                </div>
              </label>
            </div>
          </div>

          <!-- Résumé coût -->
          <div class="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl p-6 border-2 border-blue-200">
            <h3 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
              <svg class="w-5 h-5 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              Coût de l'expertise
            </h3>
            <div class="flex justify-between items-center text-xl">
              <span class="font-semibold text-gray-700">Tarif spécialiste</span>
              <span class="font-bold text-blue-700">${specialisteSelectionne.tarif} DH</span>
            </div>
            <p class="text-xs text-gray-600 mt-2">
              Ce coût s'ajoutera au coût total de la consultation (150 DH + actes techniques)
            </p>
          </div>

          <!-- Boutons d'action -->
          <div class="flex justify-end space-x-4 pt-4">
            <a href="${pageContext.request.contextPath}/generaliste/dashboard-generaliste"
               class="bg-gray-200 text-gray-700 px-6 py-3 rounded-xl font-semibold hover:bg-gray-300 transition">
              <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
              </svg>
              Annuler
            </a>
            <button type="submit"
                    id="submitBtn"
                    disabled
                    class="bg-blue-600 text-white px-6 py-3 rounded-xl font-semibold hover:bg-blue-700 transition disabled:bg-gray-400 disabled:cursor-not-allowed">
              <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/>
              </svg>
              Envoyer la demande
            </button>
          </div>
        </div>
      </div>
    </form>
  </c:if>
</div>

<script>
  // Gérer la sélection des créneaux
  document.querySelectorAll('.creneau-radio').forEach(radio => {
    radio.addEventListener('change', function() {
      // Retirer la sélection visuelle de tous les créneaux
      document.querySelectorAll('.creneau-card').forEach(card => {
        if (!card.classList.contains('disabled')) {
          card.classList.remove('border-blue-500', 'bg-blue-50');
          card.classList.add('border-green-200', 'bg-green-50');
        }
      });

      // Ajouter la sélection visuelle au créneau sélectionné
      if (this.checked) {
        this.closest('.creneau-card').classList.remove('border-green-200', 'bg-green-50');
        this.closest('.creneau-card').classList.add('border-blue-500', 'bg-blue-50');

        // Mettre à jour le champ caché
        document.getElementById('creneauIdField').value = this.value;

        // Activer le bouton de soumission
        document.getElementById('submitBtn').disabled = false;
      }
    });
  });

  // Validation avant soumission
  document.getElementById('expertiseForm')?.addEventListener('submit', function(e) {
    const creneauId = document.getElementById('creneauIdField').value;
    if (!creneauId) {
      e.preventDefault();
      alert('⚠️ Veuillez sélectionner un créneau horaire');
      return false;
    }

    const question = document.getElementById('question').value.trim();
    if (!question) {
      e.preventDefault();
      alert('⚠️ Veuillez poser une question au spécialiste');
      return false;
    }

    const priorite = document.querySelector('input[name="priorite"]:checked');
    if (!priorite) {
      e.preventDefault();
      alert('⚠️ Veuillez sélectionner un niveau de priorité');
      return false;
    }

    return confirm('Confirmer l\'envoi de la demande d\'expertise au Dr. ${specialisteSelectionne.nom} ${specialisteSelectionne.prenom} ?');
  });
</script>

</body>
</html>

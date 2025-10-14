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
  <title>Avis d'Expertise - Télé-expertise Médicale</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
    * { font-family: 'Inter', sans-serif; }
    .info-card { background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); }
    @media print {
      .no-print { display: none; }
      body { background: white; }
    }
  </style>
</head>
<body class="bg-gray-50">

<!-- Navbar -->
<nav class="bg-gradient-to-r from-blue-700 to-blue-900 shadow-lg no-print">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between items-center h-16">
      <div class="flex items-center">
        <a href="${pageContext.request.contextPath}/generaliste/dashboard-generaliste"
           class="text-white hover:text-gray-200 mr-4">
          <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
          </svg>
        </a>
        <h1 class="text-xl font-bold text-white">Avis d'Expertise Médical</h1>
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

<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

  <!-- Messages -->
  <c:if test="${not empty sessionScope.error}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-6 flex items-center no-print">
      <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
      </svg>
        ${sessionScope.error}
    </div>
    <c:remove var="error" scope="session"/>
  </c:if>

  <!-- Header with Status -->
  <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Avis d'Expertise Médical</h2>
        <p class="text-gray-600">Référence: #${demande.id}</p>
      </div>
      <div class="flex items-center space-x-3">
        <c:choose>
          <c:when test="${demande.statut eq 'TERMINEE'}">
                        <span class="px-4 py-2 bg-green-100 text-green-800 text-sm font-bold rounded-full">
                            ✓ Expertise Complétée
                        </span>
          </c:when>
          <c:otherwise>
                        <span class="px-4 py-2 bg-yellow-100 text-yellow-800 text-sm font-bold rounded-full">
                            ⏳ En Attente
                        </span>
          </c:otherwise>
        </c:choose>
        <c:choose>
          <c:when test="${demande.priorite eq 'URGENTE'}">
                        <span class="px-4 py-2 bg-red-100 text-red-800 text-sm font-bold rounded-full">
                            🔴 URGENTE
                        </span>
          </c:when>
          <c:when test="${demande.priorite eq 'NORMALE'}">
                        <span class="px-4 py-2 bg-blue-100 text-blue-800 text-sm font-bold rounded-full">
                            🔵 NORMALE
                        </span>
          </c:when>
          <c:otherwise>
                        <span class="px-4 py-2 bg-gray-100 text-gray-800 text-sm font-bold rounded-full">
                            ⚪ NON URGENTE
                        </span>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <!-- Specialist Info -->
  <div class="bg-gradient-to-r from-purple-50 to-indigo-50 rounded-xl shadow-lg p-6 mb-6 border-l-4 border-purple-500">
    <div class="flex items-center space-x-4">
      <div class="w-16 h-16 bg-purple-200 rounded-full flex items-center justify-center">
        <svg class="w-8 h-8 text-purple-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
        </svg>
      </div>
      <div class="flex-1">
        <h3 class="text-xl font-bold text-gray-900">Dr. ${demande.specialiste.nom} ${demande.specialiste.prenom}</h3>
        <p class="text-purple-700 font-semibold">
          <c:choose>
            <c:when test="${not empty demande.specialiste.specialite}">
              ${demande.specialiste.specialite.nom}
            </c:when>
            <c:otherwise>Spécialiste</c:otherwise>
          </c:choose>
        </p>
        <c:if test="${not empty demande.specialiste.tarif}">
          <p class="text-sm text-gray-600 mt-1">Tarif: ${demande.specialiste.tarif} DH</p>
        </c:if>
      </div>
      <c:if test="${not empty demande.creneau and not empty demande.creneau.dateHeure}">
        <div class="text-right">
          <p class="text-sm text-gray-600">Créneau réservé</p>
          <p class="text-lg font-bold text-gray-900">${demande.creneau.dateHeure}</p>
        </div>
      </c:if>
    </div>
  </div>

  <!-- Patient & Consultation Info -->
  <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
    <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
      <svg class="w-5 h-5 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
      </svg>
      Informations Consultation
    </h2>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div class="info-card rounded-lg p-4">
        <p class="text-sm text-gray-600 mb-1">Patient</p>
        <p class="text-lg font-bold text-gray-900">
          ${demande.consultation.patient.nom} ${demande.consultation.patient.prenom}
        </p>
        <p class="text-xs text-gray-500">ID: #${demande.consultation.patient.id}</p>
      </div>

      <div class="info-card rounded-lg p-4">
        <p class="text-sm text-gray-600 mb-1">Motif de consultation</p>
        <p class="text-lg font-bold text-gray-900">${demande.consultation.motif}</p>
      </div>

      <div class="info-card rounded-lg p-4">
        <p class="text-sm text-gray-600 mb-1">Date demande</p>
        <p class="text-lg font-bold text-gray-900">
          ${not empty demande.dateDemande ? demande.dateDemande : '-'}
        </p>
      </div>
    </div>

    <c:if test="${not empty demande.consultation.observations}">
      <div class="mt-4 p-4 bg-gray-50 rounded-lg border border-gray-200">
        <p class="text-sm font-semibold text-gray-700 mb-2">Observations initiales</p>
        <p class="text-gray-800">${demande.consultation.observations}</p>
      </div>
    </c:if>
  </div>

  <!-- Your Question -->
  <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
    <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
      <svg class="w-5 h-5 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
      </svg>
      Votre Question
    </h2>
    <div class="bg-blue-50 rounded-lg p-6 border-l-4 border-blue-500">
      <p class="text-gray-800 text-lg leading-relaxed">${demande.question}</p>
    </div>
  </div>

  <!-- Additional Data -->
  <c:if test="${not empty demande.donneesAnalyses}">
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
      <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
        <svg class="w-5 h-5 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
        </svg>
        Données et Analyses Complémentaires
      </h2>
      <div class="bg-gray-50 rounded-lg p-6 border border-gray-200">
        <p class="text-gray-800 whitespace-pre-wrap">${demande.donneesAnalyses}</p>
      </div>
    </div>
  </c:if>

  <!-- Medical Opinion (Only if completed) -->
  <c:if test="${demande.statut eq 'TERMINEE'}">
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6 border-l-4 border-green-500">
      <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
        <svg class="w-5 h-5 mr-2 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        Avis Médical du Spécialiste
      </h2>
      <div class="bg-green-50 rounded-lg p-6">
        <p class="text-gray-900 text-lg leading-relaxed whitespace-pre-wrap">${demande.avisMedical}</p>
      </div>
      <c:if test="${not empty demande.dateReponse}">
        <p class="text-sm text-gray-600 mt-3">
          <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          Répondu le: ${demande.dateReponse}
        </p>
      </c:if>
    </div>

    <!-- Recommendations -->
    <c:if test="${not empty demande.recommandations}">
      <div class="bg-white rounded-xl shadow-lg p-6 mb-6 border-l-4 border-blue-500">
        <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
          <svg class="w-5 h-5 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
          </svg>
          Recommandations et Conduite à Tenir
        </h2>
        <div class="bg-blue-50 rounded-lg p-6">
          <p class="text-gray-900 text-lg leading-relaxed whitespace-pre-wrap">${demande.recommandations}</p>
        </div>
      </div>
    </c:if>
  </c:if>

  <!-- Action Buttons -->
  <div class="flex justify-between items-center no-print">
    <a href="${pageContext.request.contextPath}/generaliste/dashboard-generaliste"
       class="inline-flex items-center px-6 py-3 bg-gray-200 text-gray-700 rounded-xl font-semibold hover:bg-gray-300 transition">
      <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
      </svg>
      Retour au Dashboard
    </a>

    <button onclick="window.print()"
            class="inline-flex items-center px-6 py-3 bg-blue-600 text-white rounded-xl font-semibold hover:bg-blue-700 transition">
      <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"/>
      </svg>
      Imprimer l'Avis
    </button>
  </div>
</div>

</body>
</html>
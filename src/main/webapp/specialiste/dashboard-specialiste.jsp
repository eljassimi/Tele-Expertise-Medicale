<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  if (session == null || session.getAttribute("user") == null ||
          !"SPECIALISTE".equals(session.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Spécialiste - Système Médical</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

    * {
      font-family: 'Inter', sans-serif;
    }

    .card {
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .card:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
    }

    .stat-card {
      background: linear-gradient(135deg, #7c3aed 0%, #6d28d9 100%);
    }

    .badge-en-attente {
      background-color: #fef3c7;
      color: #92400e;
    }

    .badge-terminee {
      background-color: #d1fae5;
      color: #065f46;
    }

    .badge-urgente {
      background-color: #fee2e2;
      color: #991b1b;
    }

    .badge-normale {
      background-color: #dbeafe;
      color: #1e40af;
    }

    .badge-non-urgente {
      background-color: #f3f4f6;
      color: #4b5563;
    }
  </style>
</head>
<body class="bg-gray-50">

<!-- Navbar -->
<nav class="bg-gradient-to-r from-purple-700 to-purple-900 shadow-lg">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between items-center h-16">
      <div class="flex items-center">
        <svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
        </svg>
        <h1 class="ml-3 text-xl font-bold text-white">Espace Spécialiste</h1>
      </div>
      <div class="flex items-center space-x-4">
                <span class="text-white">
                    <svg class="inline h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                    </svg>
                    Dr. ${sessionScope.user}
                </span>
        <a href="${pageContext.request.contextPath}/logout"
           class="bg-white text-purple-700 px-4 py-2 rounded-lg hover:bg-gray-100 transition font-semibold">
          Déconnexion
        </a>
      </div>
    </div>
  </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

  <!-- Messages -->
  <c:if test="${not empty sessionScope.success}">
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-lg mb-6 flex items-center">
      <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
      </svg>
        ${sessionScope.success}
    </div>
    <c:remove var="success" scope="session"/>
  </c:if>

  <c:if test="${not empty sessionScope.error}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-6 flex items-center">
      <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
      </svg>
        ${sessionScope.error}
    </div>
    <c:remove var="error" scope="session"/>
  </c:if>

  <!-- Gestion des créneaux -->
  <div class="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl shadow-lg p-6 mb-8 border-l-4 border-blue-500">
    <div class="flex items-center justify-between">
      <div class="flex items-center">
        <svg class="w-12 h-12 text-blue-600 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
        </svg>
        <div>
          <h3 class="text-lg font-bold text-gray-900">Gestion de vos créneaux</h3>
          <p class="text-sm text-gray-600 mt-1">
            Vous avez actuellement <span class="font-bold text-blue-600">${creneauxLibres}</span> créneaux disponibles
          </p>
        </div>
      </div>

      <div class="flex flex-col gap-2">
        <form method="post" action="${pageContext.request.contextPath}/specialiste/generer-creneaux"
              onsubmit="return confirm('Voulez-vous générer 42 nouveaux créneaux pour les 7 prochains jours ?');">
          <button type="submit"
                  class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-xl font-semibold hover:from-blue-700 hover:to-blue-800 transition shadow-lg">
            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
            </svg>
            Générer 7 jours de créneaux
          </button>
        </form>
      </div>
    </div>
  </div>

  <!-- Profile Info -->
  <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
    <div class="flex items-center justify-between">
      <div class="flex items-center">
        <div class="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center">
          <c:choose>
            <c:when test="${not empty specialiste.prenom and not empty specialiste.nom}">
                            <span class="text-purple-700 font-bold text-2xl">
                                ${specialiste.prenom.substring(0,1)}${specialiste.nom.substring(0,1)}
                            </span>
            </c:when>
            <c:otherwise>
              <span class="text-purple-700 font-bold text-2xl">SP</span>
            </c:otherwise>
          </c:choose>
        </div>
        <div class="ml-4">
          <h2 class="text-2xl font-bold text-gray-900">Dr. ${specialiste.nom} ${specialiste.prenom}</h2>
          <p class="text-gray-600">
            <c:choose>
              <c:when test="${not empty specialiste.specialite}">
                ${specialiste.specialite.nom}
              </c:when>
              <c:otherwise>
                Spécialiste
              </c:otherwise>
            </c:choose>
          </p>
          <p class="text-sm text-gray-500 mt-1">
            Tarif: <span class="font-semibold text-purple-600">
                            <c:choose>
                              <c:when test="${not empty specialiste.tarif}">
                                ${specialiste.tarif}
                              </c:when>
                              <c:otherwise>
                                0.00
                              </c:otherwise>
                            </c:choose> DH
                        </span> par consultation
          </p>
        </div>
      </div>
      <div class="text-right">
        <c:choose>
          <c:when test="${specialiste.disponible}">
                        <span class="inline-flex items-center px-3 py-1 text-sm font-semibold text-green-700 bg-green-100 rounded-full">
                            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                <circle cx="10" cy="10" r="5"/>
                            </svg>
                            Disponible
                        </span>
          </c:when>
          <c:otherwise>
                        <span class="inline-flex items-center px-3 py-1 text-sm font-semibold text-gray-700 bg-gray-200 rounded-full">
                            Indisponible
                        </span>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <!-- Statistiques -->
  <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
    <div class="stat-card rounded-xl p-6 text-white shadow-lg">
      <div class="flex items-center justify-between">
        <div>
          <p class="text-white/80 text-sm font-medium">Total demandes</p>
          <p class="text-3xl font-bold mt-2">
            <c:choose>
              <c:when test="${not empty totalDemandes}">${totalDemandes}</c:when>
              <c:otherwise>0</c:otherwise>
            </c:choose>
          </p>
        </div>
        <svg class="h-12 w-12 text-white/30" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
        </svg>
      </div>
    </div>

    <div class="bg-white rounded-xl p-6 shadow-lg border border-gray-100">
      <div class="flex items-center justify-between">
        <div>
          <p class="text-gray-600 text-sm font-medium">En attente</p>
          <p class="text-3xl font-bold text-yellow-600 mt-2">
            <c:choose>
              <c:when test="${not empty enAttenteCount}">${enAttenteCount}</c:when>
              <c:otherwise>0</c:otherwise>
            </c:choose>
          </p>
        </div>
        <svg class="h-12 w-12 text-yellow-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
      </div>
    </div>

    <div class="bg-white rounded-xl p-6 shadow-lg border border-gray-100">
      <div class="flex items-center justify-between">
        <div>
          <p class="text-gray-600 text-sm font-medium">Terminées</p>
          <p class="text-3xl font-bold text-green-600 mt-2">
            <c:choose>
              <c:when test="${not empty termineesCount}">${termineesCount}</c:when>
              <c:otherwise>0</c:otherwise>
            </c:choose>
          </p>
        </div>
        <svg class="h-12 w-12 text-green-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
      </div>
    </div>

    <div class="bg-white rounded-xl p-6 shadow-lg border border-gray-100">
      <div class="flex items-center justify-between">
        <div>
          <p class="text-gray-600 text-sm font-medium">Créneaux libres</p>
          <p class="text-3xl font-bold text-blue-600 mt-2">
            <c:choose>
              <c:when test="${not empty creneauxLibres}">${creneauxLibres}</c:when>
              <c:otherwise>0</c:otherwise>
            </c:choose>
          </p>
        </div>
        <svg class="h-12 w-12 text-blue-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
        </svg>
      </div>
    </div>
  </div>

  <!-- Actions rapides -->
  <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
    <a href="${pageContext.request.contextPath}/specialiste/demandes"
       class="card bg-white rounded-xl p-6 shadow-lg border-2 border-transparent hover:border-purple-500">
      <div class="flex items-center">
        <div class="bg-purple-100 rounded-lg p-3">
          <svg class="h-8 w-8 text-purple-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
          </svg>
        </div>
        <div class="ml-4">
          <h3 class="text-lg font-bold text-gray-900">Demandes d'expertise</h3>
          <p class="text-sm text-gray-600 mt-1">Consulter et répondre</p>
        </div>
      </div>
    </a>

    <a href="${pageContext.request.contextPath}/specialiste/creneaux"
       class="card bg-white rounded-xl p-6 shadow-lg border-2 border-transparent hover:border-purple-500">
      <div class="flex items-center">
        <div class="bg-blue-100 rounded-lg p-3">
          <svg class="h-8 w-8 text-blue-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
          </svg>
        </div>
        <div class="ml-4">
          <h3 class="text-lg font-bold text-gray-900">Mes créneaux</h3>
          <p class="text-sm text-gray-600 mt-1">Gérer ma disponibilité</p>
        </div>
      </div>
    </a>

    <a href="${pageContext.request.contextPath}/specialiste/profil"
       class="card bg-white rounded-xl p-6 shadow-lg border-2 border-transparent hover:border-purple-500">
      <div class="flex items-center">
        <div class="bg-green-100 rounded-lg p-3">
          <svg class="h-8 w-8 text-green-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
          </svg>
        </div>
        <div class="ml-4">
          <h3 class="text-lg font-bold text-gray-900">Mon profil</h3>
          <p class="text-sm text-gray-600 mt-1">Modifier mes informations</p>
        </div>
      </div>
    </a>
  </div>

  <!-- Filtres -->
  <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
    <div class="flex items-center justify-between">
      <h2 class="text-xl font-bold text-gray-900">Demandes d'expertise récentes</h2>
      <div class="flex space-x-2">
        <a href="?filter=all"
           class="px-4 py-2 rounded-lg ${empty param.filter or param.filter eq 'all' ? 'bg-purple-600 text-white' : 'bg-gray-100 text-gray-700'} hover:bg-purple-700 hover:text-white transition">
          Toutes
        </a>
        <a href="?filter=EN_ATTENTE"
           class="px-4 py-2 rounded-lg ${param.filter eq 'EN_ATTENTE' ? 'bg-purple-600 text-white' : 'bg-gray-100 text-gray-700'} hover:bg-purple-700 hover:text-white transition">
          En attente
        </a>
        <a href="?filter=TERMINEE"
           class="px-4 py-2 rounded-lg ${param.filter eq 'TERMINEE' ? 'bg-purple-600 text-white' : 'bg-gray-100 text-gray-700'} hover:bg-purple-700 hover:text-white transition">
          Terminées
        </a>
      </div>
    </div>
  </div>

  <!-- Liste des demandes -->
  <div class="bg-white rounded-xl shadow-lg overflow-hidden">
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
        <tr>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Patient
          </th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Date demande
          </th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Créneau
          </th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Priorité
          </th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Statut
          </th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Actions
          </th>
        </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
        <c:forEach items="${demandes}" var="demande">
          <tr class="hover:bg-gray-50 transition">
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="flex items-center">
                <div class="flex-shrink-0 h-10 w-10 bg-purple-100 rounded-full flex items-center justify-center">
                  <svg class="h-6 w-6 text-purple-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                  </svg>
                </div>
                <div class="ml-4">
                  <div class="text-sm font-medium text-gray-900">
                    Patient #${demande.consultation.patient.id}
                  </div>
                  <div class="text-sm text-gray-500">
                      ${demande.consultation.motif}
                  </div>
                </div>
              </div>
            </td>
            <!-- Date demande column -->
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              <c:choose>
                <c:when test="${not empty demande.dateDemande}">
                  <%=
                  ((org.medical.teleexpertisemedical.entity.DemandeExpertise)pageContext.getAttribute("demande"))
                          .getDateDemande()
                          .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
                  %>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>

            <!-- Créneau column -->
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              <c:choose>
                <c:when test="${not empty demande.creneau and not empty demande.creneau.dateHeure}">
                  <%=
                  ((org.medical.teleexpertisemedical.entity.DemandeExpertise)pageContext.getAttribute("demande"))
                          .getCreneau()
                          .getDateHeure()
                          .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
                  %>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>

            <td class="px-6 py-4 whitespace-nowrap">
              <c:choose>
                <c:when test="${demande.priorite eq 'URGENTE'}">
                                    <span class="badge-urgente px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full">
                                        🔴 Urgente
                                    </span>
                </c:when>
                <c:when test="${demande.priorite eq 'NORMALE'}">
                                    <span class="badge-normale px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full">
                                        🔵 Normale
                                    </span>
                </c:when>
                <c:otherwise>
                                    <span class="badge-non-urgente px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full">
                                        ⚪ Non urgente
                                    </span>
                </c:otherwise>
              </c:choose>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <c:choose>
                <c:when test="${demande.statut eq 'EN_ATTENTE'}">
                                    <span class="badge-en-attente px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full">
                                        En attente
                                    </span>
                </c:when>
                <c:otherwise>
                                    <span class="badge-terminee px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full">
                                        Terminée
                                    </span>
                </c:otherwise>
              </c:choose>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
              <c:choose>
                <c:when test="${demande.statut eq 'EN_ATTENTE'}">
                  <a href="${pageContext.request.contextPath}/specialiste/repondre-expertise?demandeId=${demande.id}"
                     class="text-purple-600 hover:text-purple-900 inline-flex items-center font-semibold">
                    <svg class="h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                    </svg>
                    Répondre
                  </a>
                </c:when>
                <c:otherwise>
                  <a href="${pageContext.request.contextPath}/specialiste/voir-expertise?demandeId=${demande.id}"
                     class="text-gray-600 hover:text-gray-900 inline-flex items-center">
                    <svg class="h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                    </svg>
                    Voir
                  </a>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>

        <c:if test="${empty demandes}">
          <tr>
            <td colspan="6" class="px-6 py-12 text-center text-gray-500">
              <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/>
              </svg>
              <p class="mt-2">Aucune demande d'expertise pour le moment</p>
            </td>
          </tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>

</body>
</html>

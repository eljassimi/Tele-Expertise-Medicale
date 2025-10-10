<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
  <title>Créer Consultation - Système Médical</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
    * { font-family: 'Inter', sans-serif; }
  </style>
</head>
<body class="bg-gray-50">

<!-- Navbar -->
<nav class="bg-gradient-to-r from-teal-700 to-teal-900 shadow-lg">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between items-center h-16">
      <div class="flex items-center">
        <a href="${pageContext.request.contextPath}/infirmier/liste-patients"
           class="text-white hover:text-gray-200 mr-4">
          <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
          </svg>
        </a>
        <h1 class="text-xl font-bold text-white">Créer une Consultation</h1>
      </div>
      <div class="flex items-center space-x-4">
                    <span class="text-white">
                        <svg class="inline h-5 w-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                        ${sessionScope.user}
                    </span>
        <a href="${pageContext.request.contextPath}/logout"
           class="bg-white text-teal-700 px-4 py-2 rounded-lg hover:bg-gray-100 transition font-semibold">
          Déconnexion
        </a>
      </div>
    </div>
  </div>
</nav>

<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

  <!-- Informations du patient -->
  <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
    <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
      <svg class="h-6 w-6 mr-2 text-teal-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
      </svg>
      Informations du patient
    </h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div>
        <p class="text-sm text-gray-600">Nom complet</p>
        <p class="font-semibold text-lg">${patient.nom} ${patient.prenom}</p>
      </div>
      <div>
        <p class="text-sm text-gray-600">Date de naissance</p>
        <p class="font-semibold">${patient.dateNaissance}</p>
      </div>
      <div>
        <p class="text-sm text-gray-600">N° Sécurité Sociale</p>
        <p class="font-semibold">${patient.numeroSecuriteSociale}</p>
      </div>
    </div>

    <!-- Signes vitaux récents -->
    <c:if test="${not empty patient.signesVitaux and fn:length(patient.signesVitaux) > 0}">
      <div class="mt-4 pt-4 border-t">
        <h3 class="text-sm font-semibold text-gray-700 mb-2">Signes vitaux récents</h3>
        <c:forEach items="${patient.signesVitaux}" var="signe" varStatus="status">
          <c:if test="${status.last}">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
              <c:if test="${not empty signe.tensionArterielle}">
                <div class="bg-blue-50 rounded-lg p-3">
                  <p class="text-xs text-blue-600">Tension artérielle</p>
                  <p class="font-semibold">${signe.tensionArterielle}</p>
                </div>
              </c:if>
              <c:if test="${not empty signe.frequenceCardiaque}">
                <div class="bg-red-50 rounded-lg p-3">
                  <p class="text-xs text-red-600">Fréquence cardiaque</p>
                  <p class="font-semibold">${signe.frequenceCardiaque} bpm</p>
                </div>
              </c:if>
              <c:if test="${not empty signe.temperature}">
                <div class="bg-orange-50 rounded-lg p-3">
                  <p class="text-xs text-orange-600">Température</p>
                  <p class="font-semibold">${signe.temperature}°C</p>
                </div>
              </c:if>
              <c:if test="${not empty signe.frequenceRespiratoire}">
                <div class="bg-green-50 rounded-lg p-3">
                  <p class="text-xs text-green-600">Fréquence respiratoire</p>
                  <p class="font-semibold">${signe.frequenceRespiratoire}/min</p>
                </div>
              </c:if>
            </div>
          </c:if>
        </c:forEach>
      </div>
    </c:if>

    <!-- Antécédents et allergies -->
    <c:if test="${not empty patient.antecedents || not empty patient.allergies}">
      <div class="mt-4 pt-4 border-t">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <c:if test="${not empty patient.antecedents}">
            <div>
              <p class="text-sm font-semibold text-gray-700 mb-1">Antécédents médicaux</p>
              <p class="text-sm text-gray-600 bg-gray-50 p-2 rounded">${patient.antecedents}</p>
            </div>
          </c:if>
          <c:if test="${not empty patient.allergies}">
            <div>
              <p class="text-sm font-semibold text-red-700 mb-1">⚠ Allergies</p>
              <p class="text-sm text-red-600 bg-red-50 p-2 rounded">${patient.allergies}</p>
            </div>
          </c:if>
        </div>
      </div>
    </c:if>
  </div>

  <!-- Formulaire de sélection du médecin -->
  <form action="${pageContext.request.contextPath}/infirmier/creer-consultation" method="post">
    <input type="hidden" name="patientId" value="${patient.id}"/>

    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
      <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
        <svg class="h-6 w-6 mr-2 text-teal-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/>
        </svg>
        Assigner un médecin généraliste
      </h2>
      <c:choose>
        <c:when test="${not empty generalistes}">
          <div class="grid grid-cols-1 gap-3">
            <c:forEach items="${generalistes}" var="generaliste">
              <label class="relative flex items-center p-4 border-2 border-gray-200 rounded-xl hover:border-teal-500 cursor-pointer transition">
                <input type="radio"
                       name="generalisteId"
                       value="${generaliste.id}"
                       required
                       class="h-5 w-5 text-teal-600 focus:ring-teal-500">
                <div class="ml-4 flex-1">
                  <div class="flex items-center justify-between">
                    <div>
                      <p class="font-bold text-gray-900 text-lg">
                        Dr. ${generaliste.username}
                      </p>
                      <p class="text-sm text-gray-600 mt-1">Médecin Généraliste</p>
                    </div>
                    <div class="flex items-center">
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                    <svg class="h-3 w-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                    </svg>
                                    Disponible
                                </span>
                    </div>
                  </div>
                </div>
              </label>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <div class="text-center py-8 bg-gray-50 rounded-lg border-2 border-dashed border-gray-300">
            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
            </svg>
            <h3 class="mt-2 text-sm font-medium text-gray-900">Aucun médecin généraliste disponible</h3>
            <p class="mt-1 text-sm text-gray-500">Contactez l'administrateur pour ajouter un médecin généraliste.</p>
          </div>
        </c:otherwise>
      </c:choose>

      <!-- Actions -->
      <div class="flex justify-end space-x-4 pt-4 border-t">
        <a href="${pageContext.request.contextPath}/infirmier/liste-patients"
           class="bg-gray-200 text-gray-700 px-6 py-3 rounded-xl font-semibold hover:bg-gray-300 transition">
          Annuler
        </a>
        <button type="submit"
                class="bg-teal-700 text-white px-6 py-3 rounded-xl font-semibold hover:bg-teal-800 transition inline-flex items-center"
        ${empty generalistes ? 'disabled' : ''}>
          <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
          </svg>
          Créer la consultation
        </button>
      </div>
    </div>
  </form>
</div>

</body>
</html>

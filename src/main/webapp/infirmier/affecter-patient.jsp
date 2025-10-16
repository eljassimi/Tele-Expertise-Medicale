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
  <title>Affecter Patient - Système Médical</title>
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
        <a href="${pageContext.request.contextPath}/infirmier/dashboard-infirmier"
           class="text-white hover:text-gray-200 mr-4">
          <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
          </svg>
        </a>
        <h1 class="text-xl font-bold text-white">Affecter Patient à un Généraliste</h1>
      </div>
      <div class="flex items-center space-x-4">
        <span class="text-white">${sessionScope.user}</span>
        <a href="${pageContext.request.contextPath}/logout"
           class="bg-white text-teal-700 px-4 py-2 rounded-lg hover:bg-gray-100 transition font-semibold">
          Déconnexion
        </a>
      </div>
    </div>
  </div>
</nav>

<div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

  <!-- Patient Info Card -->
  <div class="bg-gradient-to-r from-teal-50 to-cyan-50 rounded-xl shadow-lg p-6 mb-8 border-l-4 border-teal-500">
    <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
      <svg class="w-6 h-6 mr-2 text-teal-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
      </svg>
      Informations du Patient
    </h2>
    <div class="grid grid-cols-2 gap-4">
      <div>
        <p class="text-sm text-gray-600">Nom complet</p>
        <p class="text-lg font-bold text-gray-900">${patient.nom} ${patient.prenom}</p>
      </div>
      <div>
        <p class="text-sm text-gray-600">Date de naissance</p>
        <p class="text-lg font-bold text-gray-900">${patient.dateNaissance}</p>
      </div>
      <div>
        <p class="text-sm text-gray-600">N° Sécurité Sociale</p>
        <p class="text-lg font-bold text-gray-900">${patient.numeroSecuriteSociale}</p>
      </div>
      <div>
        <p class="text-sm text-gray-600">Téléphone</p>
        <p class="text-lg font-bold text-gray-900">${patient.telephone}</p>
      </div>
    </div>
  </div>

  <!-- Affectation Form -->
  <div class="bg-white rounded-xl shadow-lg p-8">
    <h2 class="text-2xl font-bold text-gray-900 mb-6">Sélectionner un Médecin Généraliste</h2>

    <form method="post" action="${pageContext.request.contextPath}/infirmier/affecter-patient">
      <input type="hidden" name="patientId" value="${patient.id}"/>

      <div class="mb-6">
        <label for="generalisteId" class="block text-sm font-semibold text-gray-700 mb-3">
          Médecin Généraliste <span class="text-red-500">*</span>
        </label>

        <c:if test="${empty generalistes}">
          <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4">
            <p class="text-yellow-700">Aucun médecin généraliste disponible</p>
          </div>
        </c:if>

        <c:if test="${not empty generalistes}">
          <div class="space-y-3">
            <c:forEach items="${generalistes}" var="generaliste">
              <label class="flex items-center p-4 border-2 border-gray-200 rounded-lg cursor-pointer hover:bg-teal-50 hover:border-teal-500 transition">
                <input type="radio"
                       name="generalisteId"
                       value="${generaliste.id}"
                       required
                       class="w-5 h-5 text-teal-600 focus:ring-teal-500"/>
                <div class="ml-4 flex-1">
                  <div class="flex items-center justify-between">
                    <div>
                      <p class="text-lg font-bold text-gray-900">
                        Dr. ${generaliste.nom} ${generaliste.prenom}
                      </p>
                      <p class="text-sm text-gray-600">${generaliste.email}</p>
                    </div>
                    <div class="bg-teal-100 text-teal-700 px-3 py-1 rounded-full text-xs font-semibold">
                      Généraliste
                    </div>
                  </div>
                </div>
              </label>
            </c:forEach>
          </div>
        </c:if>
      </div>

      <div class="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6">
        <div class="flex">
          <svg class="h-5 w-5 text-blue-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          <div>
            <h3 class="text-sm font-bold text-blue-900">Information</h3>
            <p class="text-sm text-blue-800 mt-1">
              Le patient sera affecté au généraliste sélectionné. Le médecin pourra ensuite créer la consultation.
            </p>
          </div>
        </div>
      </div>

      <div class="flex justify-end space-x-4">
        <a href="${pageContext.request.contextPath}/infirmier/dashboard-infirmier"
           class="px-6 py-3 bg-gray-200 text-gray-700 rounded-xl font-semibold hover:bg-gray-300 transition">
          Annuler
        </a>
        <button type="submit"
                class="px-6 py-3 bg-gradient-to-r from-teal-600 to-teal-700 text-white rounded-xl font-semibold hover:from-teal-700 hover:to-teal-800 transition shadow-lg">
          <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
          </svg>
          Affecter le Patient
        </button>
      </div>
    </form>
  </div>
</div>

</body>
</html>

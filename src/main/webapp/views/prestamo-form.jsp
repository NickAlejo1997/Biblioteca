<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Nuevo préstamo" />
<%@ include file="../components/header.jspf" %>

<div class="mx-auto max-w-2xl"><a href="${pageContext.request.contextPath}/app/prestamos" class="text-sm font-semibold text-indigo-600">← Volver a préstamos</a><h1 class="mt-4 font-display text-4xl font-bold text-slate-900">Registrar préstamo</h1><p class="mt-2 text-slate-500">Solo aparecen alumnos activos y libros disponibles.</p>
<c:if test="${not empty error}"><div class="mt-6 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-rose-800"><c:out value="${error}" /></div></c:if>
<form method="post" action="${pageContext.request.contextPath}/app/prestamos/guardar" class="mt-8 space-y-5 rounded-2xl border border-stone-200 bg-white p-7 shadow-sm">
    <label class="block"><span class="mb-2 block text-sm font-semibold text-slate-700">Alumno</span><select required name="idAlumno" class="w-full rounded-xl border border-stone-300 bg-white px-4 py-3 outline-none focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100"><option value="">Selecciona un alumno</option><c:forEach var="alumno" items="${alumnos}"><option value="${alumno.idAlumno}"><c:out value="${alumno.codigo}" /> · <c:out value="${alumno.nombreCompleto}" /></option></c:forEach></select></label>
    <label class="block"><span class="mb-2 block text-sm font-semibold text-slate-700">Libro</span><select required name="idLibro" class="w-full rounded-xl border border-stone-300 bg-white px-4 py-3 outline-none focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100"><option value="">Selecciona un libro</option><c:forEach var="libro" items="${libros}"><option value="${libro.idLibro}"><c:out value="${libro.titulo}" /> · <c:out value="${libro.autor}" /></option></c:forEach></select></label>
    <label class="block"><span class="mb-2 block text-sm font-semibold text-slate-700">Fecha del préstamo</span><input required type="date" name="fechaPrestamo" value="${hoy}" max="${hoy}" class="w-full rounded-xl border border-stone-300 px-4 py-3 outline-none focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100"></label>
    <c:if test="${empty libros}"><p class="rounded-xl bg-amber-50 p-3 text-sm text-amber-800">No hay libros disponibles para prestar.</p></c:if>
    <button <c:if test="${empty libros || empty alumnos}">disabled</c:if> class="w-full rounded-xl bg-indigo-600 px-5 py-3 font-semibold text-white hover:bg-indigo-700 disabled:cursor-not-allowed disabled:bg-slate-300">Confirmar préstamo</button>
</form></div>
<%@ include file="../components/footer.jspf" %>

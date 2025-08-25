const humanizeNumber = num => {
  const units = ['', 'K', 'M', 'B', 'T']
  let unitIndex = 0
  while (num >= 1000) {
    num /= 1000
    unitIndex++
  }
  return `${parseFloat(num.toFixed(1)).toLocaleString()}${units[unitIndex]}`
}

export default humanizeNumber
